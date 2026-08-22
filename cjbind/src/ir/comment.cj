package cjbind.ir

import std.collection.{ArrayList, collectArray}
import cjbind.clang

public enum CommentKind {
    SingleLines
    | MultiLine
}

func commentKind(comment: String): ?CommentKind {
    if (comment.startsWith("/*")) {
        return Some(CommentKind.MultiLine)
    } else if (comment.startsWith("//")) {
        return Some(CommentKind.SingleLines)
    } else {
        return None
    }
}

public func preprocessComment(comment: String): String {
    match (commentKind(comment)) {
        case Some(CommentKind.SingleLines) => return preprocessSingleLines(comment)
        case Some(CommentKind.MultiLine) => return preprocessMultiLines(comment)
        case None => return comment
    }
}

public func preprocessSingleLines(comment: String): String {
    let lines = comment.lines().map {
        line =>
            let trimmed = line.trimAscii()
            let markerSize = if (trimmed.startsWith("///!<")) {
                5
            } else if (trimmed.startsWith("///<") || trimmed.startsWith("//!<")) {
                4
            } else if (trimmed.startsWith("///") || trimmed.startsWith("//!")) {
                3
            } else if (trimmed.startsWith("//")) {
                2
            } else {
                0
            }
            let content = trimmed[markerSize..]
            if (content.startsWith(" ")) {
                content[1..]
            } else {
                content
            }
    } |> collectArray
    return String.join(lines, delimiter: "\n")
}

public func preprocessMultiLines(comment: String): String {
    let trimmed = comment.trimAscii()
    let markerSize = if (trimmed.startsWith("/**<") || trimmed.startsWith("/*!<")) {
        4
    } else if (trimmed.startsWith("/**") || trimmed.startsWith("/*!")) {
        3
    } else if (trimmed.startsWith("/*")) {
        2
    } else {
        0
    }
    let end = trimmed.lastIndexOf("*/").getOrDefault({=> trimmed.size})
    if (end <= markerSize) {
        return ""
    }

    let body = trimmed[markerSize..end]
    let lines = body.lines().map {
        line => line.trimAscii().trimStart([r'*']).trimAscii()
    } |> collectArray

    var first = 0
    var last = lines.size
    while (first < last && lines[first].isEmpty()) {
        first++
    }
    while (last > first && lines[last - 1].isEmpty()) {
        last--
    }

    let ret = StringBuilder()
    for (index in first..last) {
        if (index > first) {
            ret.append("\n")
        }
        ret.append(lines[index])
    }
    return ret.toString()
}

class CommentSourcePoint {
    let fileName: String
    let line: UInt32
    let offset: UInt32

    init(location: clang.SourceLocation) {
        let (file, line, _, offset) = location.location()
        this.fileName = file.name().getOrDefault({=> ""})
        this.line = line
        this.offset = offset
    }

    func sameFile(other: CommentSourcePoint): Bool {
        return this.fileName == other.fileName
    }
}

class CommentSourceChild {
    let key: String
    let kind: clang.CXCursorKind
    let start: CommentSourcePoint
    let end: CommentSourcePoint

    init(cursor: clang.Cursor, range: clang.SourceRange) {
        let location = CommentSourcePoint(cursor.location())
        this.key = "${location.fileName}:${location.offset}"
        this.kind = cursor.kind()
        this.start = CommentSourcePoint(range.startLocation())
        this.end = CommentSourcePoint(range.endLocation())
    }
}

class MemberCommentEntry {
    let key: String
    let parts = ArrayList<String>()

    init(key: String) {
        this.key = key
    }
}

// Resolve comments from the compound declaration's raw tokens instead of
// trusting libclang's declaration attachment. Unmarked documentation comments
// written after a member are otherwise attached to the next member, and enum
// comments can be repeated across later undocumented constants.
class MemberComments {
    let memberKind: clang.CXCursorKind
    let children = ArrayList<CommentSourceChild>()
    let comments = ArrayList<MemberCommentEntry>()

    init(parent: clang.Cursor, memberKind: clang.CXCursorKind) {
        this.memberKind = memberKind
        for (child in parent.collectChildren()) {
            if (let Some(range) <- child.sourceRange()) {
                children.add(CommentSourceChild(child, range))
            }
        }

        if (!children.any({child => child.kind == memberKind})) {
            return
        }

        let tokens = clang.RawTokens(parent)
        try {
            for (token in tokens) {
                if (token.kind != clang.CXTokenKind_CXToken_Comment) {
                    continue
                }

                let rawComment = token.spelling()
                let comment = preprocessComment(rawComment)
                if (comment.trimAscii().isEmpty()) {
                    continue
                }

                let range = token.sourceRange()
                let start = CommentSourcePoint(range.startLocation())
                let end = CommentSourcePoint(range.endLocation())
                if (this.isInsideChild(start, end)) {
                    continue
                }

                let previous = this.previousChild(start)
                let next = this.nextChild(end)
                if (isExplicitTrailingComment(rawComment)) {
                    if (let Some(child) <- previous && child.kind == memberKind) {
                        this.add(child.key, comment)
                    }
                    continue
                }

                if (let Some(child) <- previous && child.kind == memberKind && child.end.line == start.line) {
                    let nextIsOnSameLine = next
                        .map({candidate => candidate.start.line == start.line && candidate.start.sameFile(start)})
                        .getOrDefault({=> false})
                    if (!nextIsOnSameLine) {
                        this.add(child.key, comment)
                        continue
                    }
                }

                if (isDocumentationComment(rawComment)) {
                    if (let Some(child) <- next && child.kind == memberKind) {
                        this.add(child.key, comment)
                    }
                }
            }
        } finally {
            tokens.close()
        }
    }

    func comment(cursor: clang.Cursor): ?String {
        let key = sourceKey(cursor)
        for (entry in comments) {
            if (entry.key == key) {
                return Some(String.join(entry.parts.toArray(), delimiter: "\n"))
            }
        }

        return None
    }

    func preservesParsedComment(cursor: clang.Cursor): Bool {
        let resolved = this.comment(cursor)
        let raw = cursor.rawComment().map({comment => preprocessComment(comment)})
        return resolved == raw
    }

    func add(key: String, comment: String): Unit {
        if (!this.hasUniqueTargetKey(key)) {
            return
        }
        for (entry in comments) {
            if (entry.key == key) {
                entry.parts.add(comment)
                return
            }
        }
        let entry = MemberCommentEntry(key)
        entry.parts.add(comment)
        comments.add(entry)
    }

    func hasUniqueTargetKey(key: String): Bool {
        // Macro-expanded members can share one expansion location. Refuse to
        // guess in that case because a key-based association would duplicate
        // one comment across every expanded member.
        var count = 0
        for (child in children) {
            if (child.kind == memberKind && child.key == key) {
                count++
            }
        }
        return count == 1
    }

    func isInsideChild(start: CommentSourcePoint, end: CommentSourcePoint): Bool {
        for (child in children) {
            if (child.start.sameFile(start) && child.end.sameFile(end) && start.offset >= child.start.offset &&
                end.offset <= child.end.offset) {
                return true
            }
        }
        return false
    }

    func previousChild(location: CommentSourcePoint): ?CommentSourceChild {
        var previous: ?CommentSourceChild = None
        for (child in children) {
            if (!child.end.sameFile(location) || child.end.offset > location.offset) {
                continue
            }
            match (previous) {
                case Some(value) =>
                    if (child.end.offset > value.end.offset) {
                        previous = Some(child)
                    }
                case None => previous = Some(child)
            }
        }
        return previous
    }

    func nextChild(location: CommentSourcePoint): ?CommentSourceChild {
        var next: ?CommentSourceChild = None
        for (child in children) {
            if (!child.start.sameFile(location) || child.start.offset < location.offset) {
                continue
            }
            match (next) {
                case Some(value) =>
                    if (child.start.offset < value.start.offset) {
                        next = Some(child)
                    }
                case None => next = Some(child)
            }
        }
        return next
    }
}

func sourceKey(cursor: clang.Cursor): String {
    let point = CommentSourcePoint(cursor.location())
    return "${point.fileName}:${point.offset}"
}

func isExplicitTrailingComment(comment: String): Bool {
    let trimmed = comment.trimAscii()
    return trimmed.startsWith("///<") || trimmed.startsWith("//!<") || trimmed.startsWith("/**<") || trimmed
        .startsWith("/*!<")
}

func isDocumentationComment(comment: String): Bool {
    let trimmed = comment.trimAscii()
    return trimmed.startsWith("///") || trimmed.startsWith("//!") || trimmed.startsWith("/**") || trimmed.startsWith(
        "/*!")
}
