+++
title = "Coding The Rusty Matrix: Chapter 1"
date = 2019-04-11

[taxonomies]
tags = ["rust", "math", "coding-the-matrix"]

[extra]
+++

This is the first part of a series about working through [Coding The
Matrix: Linear Algebra Through Computer Science
Applications](https://codingthematrix.com/) using rust instead of python3.


## 1.2 Complex Numbers in Rust

To use complex numbers in rust we can add the
[`num-complex`](https://github.com/rust-num/num-complex) crate as
a dependency for our project:

```toml
[dependencies]
num-complex = "0.2"
```

The following snippet shows some of what we can do with
`Complex<{integer}>`:

```rust
// src/bin/example_1_2_1/main.rs
// Coding The Matrix Chapter 1.2
// Basics of num_complex::Complex

use num_complex::Complex;

fn main() {
    // Square root of -9, the imaginary number 3i, is written:
    let comp0 = Complex::new(0, 3);

    // Complex number 1 + 3i is written:
    let comp1 = Complex::new(1, 3);

    // Complex number 10 - 20i is written:
    let comp2 = Complex::new(10, -20);

    // A number of operations are defined for complex numbers
    println!("{} + {} = {}", comp1 , comp2, comp1 + comp2);
    println!("{} - {} = {}", comp1 , comp2, comp1 - comp2);
    println!("{} * {} = {}", comp1 , comp2, comp1 * comp2);
    println!("{} / {} = {}", comp1 , comp2, comp1 / comp2);

    // These operations can also be used with non-complex numbers
    println!("{} * 3 = {}", comp1, comp1 * 3);
}
```

The output of the above is:

```
1+3i + 10-20i = 11-17i
1+3i - 10-20i = -9+23i
1+3i * 10-20i = 70+10i
1+3i / 10-20i = 0+0i
1+3i * 3 = 3+9i
```

## 1.3 Abstracting Over Fields

In python to solve an equation in the form $ax + b = c$ where $a$ is
nonzero we can use the function:

```python
def solve1(a, b, c):
    return (c - b) / a
```

We can write a similar function in rust by using generics.

The `solve1` implementation below accepts 3 arguments of generic type `T`.
The `where` clause tells the compiler that `T` must implement the
`std::ops::Div` and `std::ops::Sub` traits (corresponding to `/` and `-`
operators). `Copy` is required for dividing the result of `c - b`, as the
`Div` trait takes arguments by value.

```rust
// src/bin/example_1_3_1/main.rs
// Coding The Matrix Chapter 1.3
// Making use of overloaded operators

use num_complex::Complex;
use std::fmt::Display;
use std::ops::{Div, Sub};

fn solve1<T>(a: T, b: T, c: T) -> T
where
    T: Sub<Output = T> + Div<Output = T> + Display + Copy,
{
    (c - b) / a
}

fn main() {
    println!("solve1(10, 5, 30)) = {}", solve1(10, 5, 30));
    println!("solve1(10.0, 5.0, 30.0)) = {}", solve1(10.0, 5.0, 30.0));
    println!(
        "solve1(10+5i, 5, 20)) = {}",
        solve1(
            Complex::new(10.0, 5.0),
            Complex::new(5.0, 0.0),
            Complex::new(20.0, 0.0)
        )
    );
}
```


The output of the above is:

```
solve1(10, 5, 30)) = 2
solve1(10.0, 5.0, 30.0)) = 2.5
solve1(10+5i, 5, 20)) = 1.2-0.6i
```


## 1.4 Playing With Complex Numbers

Because each `num_complex::Complex` number `z` consists of two ordinary
numbers `z.re` (the real part) and `z.im` (the imaginary part), it is
traditional to think of `z` as specifying a _point_ in the _complex
plane_.
