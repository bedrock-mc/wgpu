//! Matrix inverse helper functions for the C-like backends (HLSL and MSL),
//! which have no `inverse` builtin.
//!
//! Like the WGSL backend's polyfills (`back/wgsl/polyfill/inverse`), the inverse
//! is computed as the adjugate divided by the determinant.

use alloc::{format, string::String};
use core::fmt::{self, Write};

use crate::back::Level;

/// Writes the function `matrix_ty fun_name(matrix_ty m)` returning the inverse
/// of the square `size`x`size` matrix `m`.
///
/// `m[i][j]` must index row `j` of column `i`, as naga matrices do in HLSL and
/// MSL. `scalar_ty` is the type of the matrix components.
pub(super) fn write_inverse_function(
    out: &mut impl Write,
    fun_name: &str,
    size: crate::VectorSize,
    matrix_ty: &str,
    scalar_ty: &str,
) -> fmt::Result {
    let n = size as usize;
    let all: [usize; 4] = [0, 1, 2, 3];
    let l1 = Level(1);

    writeln!(out, "{matrix_ty} {fun_name}({matrix_ty} m) {{")?;
    writeln!(out, "{l1}{matrix_ty} adj;")?;
    // The inverse at column `c`, row `r` is the cofactor of `m[r][c]` over the
    // determinant.
    for c in 0..n {
        for r in 0..n {
            let columns: arrayvec::ArrayVec<usize, 4> =
                all[..n].iter().copied().filter(|&i| i != r).collect();
            let rows: arrayvec::ArrayVec<usize, 4> =
                all[..n].iter().copied().filter(|&i| i != c).collect();
            let sign = if (r + c) % 2 == 0 { "" } else { "-" };
            writeln!(
                out,
                "{l1}adj[{c}][{r}] = {sign}{};",
                determinant(&columns, &rows)
            )?;
        }
    }
    // Expand the determinant along the first row; `adj[0][x]` is the cofactor
    // of `m[x][0]`.
    write!(out, "{l1}{scalar_ty} det = ")?;
    for x in 0..n {
        let plus = if x == 0 { "" } else { " + " };
        write!(out, "{plus}m[{x}][0] * adj[0][{x}]")?;
    }
    writeln!(out, ";")?;
    writeln!(out, "{l1}return adj * ({scalar_ty}(1) / det);")?;
    writeln!(out, "}}")?;
    writeln!(out)
}

/// Returns an expression for the determinant of the submatrix of `m` made of
/// `columns` and `rows`, expanded along its first column.
fn determinant(columns: &[usize], rows: &[usize]) -> String {
    let c = columns[0];
    match rows.len() {
        1 => format!("m[{c}][{}]", rows[0]),
        _ => {
            let mut expr = String::from("(");
            for (k, &r) in rows.iter().enumerate() {
                let minor_rows: arrayvec::ArrayVec<usize, 4> =
                    rows.iter().copied().filter(|&other| other != r).collect();
                let op = match (k, k % 2) {
                    (0, _) => "",
                    (_, 0) => " + ",
                    _ => " - ",
                };
                expr += &format!(
                    "{op}m[{c}][{r}] * {}",
                    determinant(&columns[1..], &minor_rows)
                );
            }
            expr.push(')');
            expr
        }
    }
}
