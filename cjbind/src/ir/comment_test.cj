package cjbind.ir

import std.unittest.*
import std.unittest.testmacro.*

@Test
public class CommentPreprocessingTest {
    @TestCase
    func removesLineDocumentationMarkers(): Unit {
        @Expect(preprocessComment("/// leading"), "leading")
        @Expect(preprocessComment("///< trailing"), "trailing")
        @Expect(preprocessComment("//!< trailing"), "trailing")
        @Expect(preprocessComment("///!< malformed trailing"), "malformed trailing")
    }

    @TestCase
    func removesBlockDocumentationMarkers(): Unit {
        @Expect(preprocessComment("/** leading */"), "leading")
        @Expect(preprocessComment("/**< trailing */"), "trailing")
        @Expect(preprocessComment("/*!< trailing */"), "trailing")
        @Expect(preprocessComment("/* ordinary */"), "ordinary")
    }

    @TestCase
    func preservesIndentationAfterTheSeparator(): Unit {
        @Expect(preprocessComment("///   indented"), "  indented")
    }

    @TestCase
    func removesOnlyOuterBlankBlockLines(): Unit {
        @Expect(preprocessComment("/**\n * first\n *\n * second\n */"), "first\n\nsecond")
    }

    @TestCase
    func preservesMpvListAndExampleIndentation(): Unit {
        let raw = "/**\n" + " * - No config files\n" + " *   --config=no\n" + " *   For example:\n" +
            " *      mpv_set_option_string();\n" + " */"
        let expected = "- No config files\n  --config=no\n  For example:\n     mpv_set_option_string();"
        @Expect(preprocessComment(raw), expected)
    }

    @TestCase
    func preservesFfmpegDoxygenCodeIndentation(): Unit {
        let raw = "/**\n" + " * @code\n" + " * if (ret < 0)\n" + " *     abort();\n" + " * @endcode\n" + " */"
        let expected = "@code\nif (ret < 0)\n    abort();\n@endcode"
        @Expect(preprocessComment(raw), expected)
    }

    @TestCase
    func preservesSdlMarkdownStructure(): Unit {
        let raw = "/**\n" + " * - Assertions disappear in release builds.\n" +
            " *   Referenced variables remain checked.\n" + " *\n" + " * ```c\n" + " * while (item) {\n" +
            " *    use(item);\n" + " * }\n" + " * ```\n" + " */"
        let expected = "- Assertions disappear in release builds.\n" +
            "  Referenced variables remain checked.\n\n```c\nwhile (item) {\n   use(item);\n}\n```"
        @Expect(preprocessComment(raw), expected)
    }

    @TestCase
    func recognizesOpenSslPreservedLayoutBlocks(): Unit {
        let raw = "/*-\n" + " * A CHOICE declaration looks like this:\n" + " *\n" + " *      ASN1_CHOICE(name) = {\n" +
            " *              ... options ...\n" + " *      }\n" + " */"
        let expected = "A CHOICE declaration looks like this:\n\n" +
            "     ASN1_CHOICE(name) = {\n             ... options ...\n     }"
        @Expect(preprocessComment(raw), expected)
    }

    @TestCase
    func preservesCurlNestedCodeIndentation(): Unit {
        let raw = "/* To add a warning, add an\n" + " *   if (is_option(value))\n" + " *     if (!is_type(value))\n" +
            " *       report_type_error();\n" + " */"
        let expected = "To add a warning, add an\n  if (is_option(value))\n" +
            "    if (!is_type(value))\n      report_type_error();"
        @Expect(preprocessComment(raw), expected)
    }

    @TestCase
    func preservesLibuvListContinuationIndentation(): Unit {
        let raw = "/*\n" + " *  - every path has the same number of black nodes,\n" +
            " *    including paths through leaf nodes.\n" + " */"
        let expected = "- every path has the same number of black nodes,\n" + "  including paths through leaf nodes."
        @Expect(preprocessComment(raw), expected)
    }

    @TestCase
    func preservesRelativeIndentationWithoutLineStars(): Unit {
        let raw = "/*!\n    prose\n      indented prose\n    */"
        @Expect(preprocessComment(raw), "prose\n  indented prose")
    }

    @TestCase
    func recognizesFfmpegColumnZeroStarDecoration(): Unit {
        let raw = "/**\n* Error handling helper\n*/"
        @Expect(preprocessComment(raw), "Error handling helper")
    }

    @TestCase
    func recognizesSqliteDoubleStarDecoration(): Unit {
        let raw = "/*\n** CAPI reference\n**\n** Interface details\n*/"
        @Expect(preprocessComment(raw), "CAPI reference\n\nInterface details")
    }
}
