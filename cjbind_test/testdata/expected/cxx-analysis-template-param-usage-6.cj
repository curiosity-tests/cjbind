package cjbind_ffi

public type DoesNotUseTemplateParameter_ButAliasDoesUseIt<T> = T

// cjbind-options: -- -x c++ -std=c++14
@C
public struct DoesNotUseTemplateParameter {
    public var x: Int32
    private init(x: Int32) {
        this.x = x
    }
}
