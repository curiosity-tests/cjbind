package cjbind_ffi

// cjbind-options: -- --target=i686-pc-win32
//
// We can only check that this builds, but not that it actually passes, because
// we have no CI on the target platform.
@C
public struct JNINativeInterface_ {
    let _cjbind_opaque_blob: VArray<UInt64, $2>
    private init() {
        this._cjbind_opaque_blob = unsafe { zeroValue<VArray<UInt64, $2>>() }
    }
}

@CallingConv[STDCALL]
foreign func bar(): Unit
