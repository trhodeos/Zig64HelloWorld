pub const Video = struct {
    const VI_BASE = @intToPtr([*]volatile u32, 0xA4400000);
    pub const VideoStatusFlags = struct {
        pub const BPP32 = 0x3;

        pub const INTERLACE = 0x40;

        pub const AA_MODE_2 = 0x200;
    };

    pub fn setupNtsc(width: u32, height: u32, status: u32, origin: u32) void {
        // Pulled from https://github.com/PeterLemon/N64/blob/master/CPUTest/CPU/ADD/LIB/N64_GFX.INC
        VI_BASE[0x0] = status;
        VI_BASE[0x1] = origin;
        VI_BASE[0x2] = width;
        // Vertical interrupt
        VI_BASE[0x3] = 200;
        // Current Vertical line (Current Half-line, sampled once per line).
        VI_BASE[0x4] = 0;
        // Video Timing (Start Of Color Burst In Pixels from H-Sync = 3, Vertical Sync Width In Half Lines = 229, Color Burst Width In Pixels = 34, Horizontal Sync Width In Pixels = 57)
        VI_BASE[0x5] = 0x3E52239;
        // Vertical Sync (Number Of Half-Lines Per Field = 525)
        VI_BASE[0x6] = 0x20D;
        // Horizontal Sync (5-bit Leap Pattern Used For PAL only = 0, Total Duration Of A Line In 1/4 Pixel = 3093)
        VI_BASE[0x7] = 0xC15;
        // Horizontal Sync Leap (Identical To H Sync = 3093, Identical To H Sync = 3093)
        VI_BASE[0x8] = 0xC150C15;
        // Horizontal Video (Start Of Active Video In Screen Pixels = 108, End Of Active Video In Screen Pixels = 748)
        VI_BASE[0x9] = 0x6C02EC;
        // Vertical Video (Start Of Active Video In Screen Half-Lines = 37, End Of Active Video In Screen Half-Lines = 511)
        VI_BASE[0xA] = 0x2501FF;
        // Vertical Burst (Start Of Color Burst Enable In Half-Lines = 14, End Of Color Burst Enable In Half-Lines = 516)
        VI_BASE[0xB] = 0xE0204;
        // X-Scale (Horizontal Subpixel Offset In 2.10 Format = 0, 1/Horizontal Scale Up Factor In 2.10 Format)
        VI_BASE[0xC] = 100 * width / 160;
        // Y-Scale (Vertical Subpixel Offset In 2.10 Format = 0, 1/Vertical Scale Up Factor In 2.10 Format)
        VI_BASE[0xD] = 100 * height / 60;
    }
};
