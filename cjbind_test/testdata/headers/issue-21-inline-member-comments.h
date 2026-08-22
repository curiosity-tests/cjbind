/** Mixed inline member comment styles. */
typedef enum issue_21_level {
    ISSUE_21_NONE = 0, /// unmarked line documentation
    ISSUE_21_FATAL = 1, ///< marked line documentation
    ISSUE_21_ERROR = 2, /** unmarked block documentation */
    ISSUE_21_WARN = 3, /**< marked block documentation */
    ISSUE_21_INFO = 4, // ordinary line comment
    ISSUE_21_DEBUG = 5, /* ordinary block comment */
    /// leading line documentation
    ISSUE_21_TRACE = 6,
    ISSUE_21_UNDOCUMENTED = 7,
    ISSUE_21_MALFORMED = 8, ///!< malformed marked line documentation
    ISSUE_21_LAST = 9, /// final unmarked line documentation
} issue_21_level;

/** Fields with mixed inline comment styles. */
typedef struct issue_21_fields {
    int line_doc; /// field unmarked line documentation
    int block_doc; /** field unmarked block documentation */
    int ordinary_line; // field ordinary line comment
    int ordinary_block; /* field ordinary block comment */
    /** field leading documentation */
    int leading;
    int undocumented;
    int malformed; ///!< field malformed marked line documentation
    int last; /// field final unmarked line documentation
} issue_21_fields;
