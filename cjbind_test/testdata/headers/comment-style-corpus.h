/* Formatting-only samples with synthetic prose, minimized from:
 * - mpv include/mpv/client.h @ 49418246f30a
 * - FFmpeg libavformat/avformat.h and libavcodec/amfenc.h @ eb0bfa852e7b
 * - SDL include/SDL3/SDL_assert.h @ a0db66a7188c
 * - OpenSSL include/openssl/asn1t.h.in @ b64f68a94e61
 * - curl include/curl/typecheck-gcc.h @ 6c04b424bd0a
 * - libuv include/uv/tree.h @ f87c8e4f70f2
 * - SQLite src/sqlite.h.in @ 45f4f1c1cba7
 */

/**
 * - No config files are loaded.
 *   --config=no can be overridden.
 *   For example:
 *      set_config_root();
 */
void comment_style_mpv(void);

/**
 * Open an input as follows:
 * @code
 * if (open_input() < 0)
 *     abort();
 * @endcode
 */
void comment_style_ffmpeg(void);

/**
* Column-zero star decoration is also accepted.
*/
void comment_style_ffmpeg_column_zero(void);

/**
 * - Assertions disappear in release builds.
 *   Referenced variables remain checked.
 *
 * ```c
 * while (item) {
 *    use(item);
 * }
 * ```
 */
void comment_style_sdl(void);

typedef enum comment_style_ordinary {
    COMMENT_STYLE_OPENSSL = 0, /*-
                               * A CHOICE declaration looks like this:
                               *
                               *      ASN1_CHOICE(name) = {
                               *              ... options ...
                               *      }
                               */
    COMMENT_STYLE_CURL = 1, /* To add a warning, add an
                             *   if (is_option(value))
                             *     if (!is_type(value))
                             *       report_type_error();
                             */
    COMMENT_STYLE_LIBUV = 2, /*
                              *  - every path has the same number of black nodes,
                              *    including paths through leaf nodes.
                              */
    COMMENT_STYLE_SQLITE = 3, /*
** CAPI reference
**
** Interface details
*/
} comment_style_ordinary;
