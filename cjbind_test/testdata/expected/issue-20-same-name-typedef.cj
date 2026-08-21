package cjbind_ffi

@C
public struct mpv_handle {
    init() {
        throw Exception("type should not be inited")
    }
}

public const mpv_error_MPV_ERROR_SUCCESS: mpv_error = 0
public const mpv_error_MPV_ERROR_EVENT_QUEUE_FULL: mpv_error = -1

public type mpv_error = Int32
