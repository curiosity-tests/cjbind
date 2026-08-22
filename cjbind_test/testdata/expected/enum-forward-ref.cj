package cjbind_ffi

public const Foo_A: Foo = 0

// A forward reference to an enum should work..
public type Foo = Int32

public const Bar_B: Bar = 0

// A reference to an enum after the definition should work.
public type Bar = UInt32

// A forward reference to an enum in a function definition should work.
foreign func f(): Baz

public const Baz_C: Baz = 0

public type Baz = Int32

// A forward reference to an enum with no later definition should result in
// a guess of the underlying type (i32).
public type Qux = Int32
