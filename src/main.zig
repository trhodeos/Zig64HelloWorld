const N64 = @import("n64.zig").N64;
const Video = @import("video.zig").Video;

export var gameHeader linksection(".n64header") = N64.Header.setup("HELLOWORLD");

pub fn main() noreturn {
    const dram = @intToPtr([*]volatile u32, 0xA0100000);
    const width = 640;
    const height = 480;

    Video.setupNtsc(width, height, Video.VideoStatusFlags.BPP32 | Video.VideoStatusFlags.INTERLACE | Video.VideoStatusFlags.AA_MODE_2, 0xA0100000);
    var i: usize = 0;
    while (i < width * height) {
        dram[i] = 0xFFFFFFFF;
        i += 1;
    }

    while (true) {}
}
