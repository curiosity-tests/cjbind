package cjbind_ffi

// foo.h
public type myVector3 = VArray<Float32, $3>

foreign func modifyVectorFunc(v: CPointer<Float32>): Unit
