package cjbind_ffi

public const RTE_CACHE_LINE_MIN_SIZE: Int64 = 64
public const RTE_CACHE_LINE_SIZE: Int64 = 64

// The kernel image of the rte_mbuf struct, with only the relevant fields.
// Padding is necessary to assure the offsets of these fields
@C
public struct rte_kni_mbuf {
    let _cjbind_opaque_blob: VArray<UInt8, $128>
    private init() {
        this._cjbind_opaque_blob = unsafe { zeroValue<VArray<UInt8, $128>>() }
    }
}
