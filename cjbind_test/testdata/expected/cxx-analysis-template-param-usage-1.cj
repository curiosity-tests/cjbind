package cjbind_ffi

// cjbind-options: -- -x c++ -std=c++14
@C
public struct DoesNotUseTemplateParameter {
    public var x: Int32
    private init(x: Int32) {
        this.x = x
    }
}
