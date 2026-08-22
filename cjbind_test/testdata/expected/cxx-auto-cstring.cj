package cjbind_ffi

// cjbind-options: --auto-cstring -- -x c++ -std=c++14
foreign func _Z10passStringPc(value: CString): CString

// cjbind-options: --auto-cstring -- -x c++ -std=c++14
public unsafe func passString(value: CString): CString {
    return _Z10passStringPc(value)
}

foreign func _Z13passCharacterRc(value: CPointer<UInt8>): CPointer<UInt8>

public unsafe func passCharacter(value: CPointer<UInt8>): CPointer<UInt8> {
    return _Z13passCharacterRc(value)
}

foreign func _Z18passConstCharacterRKc(value: CPointer<UInt8>): CPointer<UInt8>

public unsafe func passConstCharacter(value: CPointer<UInt8>): CPointer<UInt8> {
    return _Z18passConstCharacterRKc(value)
}
