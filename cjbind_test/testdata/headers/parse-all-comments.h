/* Ordinary function documentation.
 *
 * Example:
 *     parse_all_function();
 */
int parse_all_function(void);

/* Ordinary enum documentation. */
typedef enum parse_all_kind {
    /* ordinary leading member */
    PARSE_ALL_LEADING = 0,
    PARSE_ALL_TRAILING = 1, /* ordinary trailing member */
    /*< nick=structured >*/
    PARSE_ALL_STRUCTURED = 2,
    /*
     * Member code:
     *     parse_all_member();
     */
    PARSE_ALL_CODE = 3,
    PARSE_ALL_NONE = 4,
} parse_all_kind;

/* Ordinary structure documentation. */
typedef struct parse_all_fields {
    /* ordinary leading field */
    int leading;
    int trailing; /* ordinary trailing field */
    /*< private >*/
    int structured;
    /*
     * Field code:
     *     parse_all_field();
     */
    int code;
    int none;
} parse_all_fields;
