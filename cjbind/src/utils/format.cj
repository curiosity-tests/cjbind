package cjbind.utils

import std.env
import std.process.{launch, ProcessRedirect}
import std.fs.{Directory, File, remove}

public func formatString(f: String): String {
    let tmpDir = Directory.createTemp(env.getTempDirectory())

    try {
        let temp = tmpDir.join("cjbind.cj")
        File.writeTo(temp, f.toArray())

        try {
            let process = launch(
                "cjfmt",
                ["-f", temp.toString()],
                stdIn: ProcessRedirect.Discard,
                stdOut: ProcessRedirect.Discard,
                stdErr: ProcessRedirect.Discard
            )
            let code = process.wait()
            if (code != 0) {
                throw Exception("cjfmt 失败")
            }
        } catch (e: Exception) {
            eprintln("cjfmt 失败: ${e.toString()}")
            return f
        }

        let out = String.fromUtf8(File.readFrom(temp))

        return out
    } finally {
        remove(tmpDir, recursive: true)
    }
}
