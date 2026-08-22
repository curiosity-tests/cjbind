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
}
