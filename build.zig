const Builder = @import("std").build.Builder;
const builtin = @import("std").builtin;
const std = @import("std");

pub fn build(b: *Builder) void {
    const exe = b.addExecutable("N64HelloWorld", "src/main.zig");

    exe.setTheTarget(std.Target {
        .Cross = std.Target.Cross {
            .arch = std.Target.Arch {
                .mips = {}
            },
            .os = .freestanding,
            .abi = .none
        }
    });

    exe.setOutputDir("zig-cache/raw");
    exe.setLinkerScriptPath("n64.ld");
    exe.setBuildMode(builtin.Mode.ReleaseFast);

    const objCopyCommand = if (builtin.os == builtin.Os.windows) "C:\\Programmation\\Zig\\llvm+clang-9.0.0-win64-msvc-mt\\bin\\llvm-objcopy.exe" else "llvm-objcopy";

    const buildRomCommand = b.addSystemCommand(&[_][]const u8 {
        objCopyCommand, exe.getOutputPath(),
        "-O", "binary",
        "zig-cache/bin/N64HelloWorld.n64",
    });

    buildRomCommand.step.dependOn(&exe.step);

    b.default_step.dependOn(&buildRomCommand.step);
}
