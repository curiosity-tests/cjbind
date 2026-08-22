package cjbind_ffi

// cjbind-options: -- -x c++ -std=c++14
@C
public struct DoesNotUseT {
    let _cjbind_empty: UInt8
    private init(_cjbind_empty: UInt8) {
        this._cjbind_empty = _cjbind_empty
    }
}
