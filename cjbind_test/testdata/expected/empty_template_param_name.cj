package cjbind_ffi

// cjbind-options: -- -x c++ -std=c++11
public type __void_t = Unit

@C
public struct __iterator_traits {
    let _cjbind_empty: UInt8
    private init(_cjbind_empty: UInt8) {
        this._cjbind_empty = _cjbind_empty
    }
}
