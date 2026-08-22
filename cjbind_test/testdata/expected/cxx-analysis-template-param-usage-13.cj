package cjbind_ffi

// cjbind-options: -- -x c++ -std=c++14
@C
public struct BaseIgnoresT {
    public var x: Int32
    private init(x: Int32) {
        this.x = x
    }
}
