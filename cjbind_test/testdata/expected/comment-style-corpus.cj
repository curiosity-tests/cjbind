package cjbind_ffi

// - No config files are loaded.
//   --config=no can be overridden.
//   For example:
//      set_config_root();
foreign func comment_style_mpv(): Unit

// Open an input as follows:
// @code
// if (open_input() < 0)
//     abort();
// @endcode
foreign func comment_style_ffmpeg(): Unit

// Column-zero star decoration is also accepted.
foreign func comment_style_ffmpeg_column_zero(): Unit

// - Assertions disappear in release builds.
//   Referenced variables remain checked.
//
// ```c
// while (item) {
//    use(item);
// }
// ```
foreign func comment_style_sdl(): Unit

// A CHOICE declaration looks like this:
//
//      ASN1_CHOICE(name) = {
//              ... options ...
//      }
public const comment_style_ordinary_COMMENT_STYLE_OPENSSL: comment_style_ordinary = 0

// To add a warning, add an
//   if (is_option(value))
//     if (!is_type(value))
//       report_type_error();
public const comment_style_ordinary_COMMENT_STYLE_CURL: comment_style_ordinary = 1

// - every path has the same number of black nodes,
//   including paths through leaf nodes.
public const comment_style_ordinary_COMMENT_STYLE_LIBUV: comment_style_ordinary = 2

// CAPI reference
//
// Interface details
public const comment_style_ordinary_COMMENT_STYLE_SQLITE: comment_style_ordinary = 3

public type comment_style_ordinary = UInt32
