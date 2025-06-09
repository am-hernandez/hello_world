fn main(x: Field, y: pub Field) {
    assert(x != y, "x and y must be different");
}

#[test]
fn test_main() {
    // main(1, 2);

    // Uncomment to make test fail
    main(1, 1);
}
