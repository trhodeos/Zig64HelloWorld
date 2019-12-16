const root = @import("root");
const isUpper = @import("std").ascii.isUpper;
const isDigit = @import("std").ascii.isDigit;

pub const N64 = struct {
    pub const Header = packed struct {
        piBsbDom1LatReg: u8,
        piBsbDom1PgsReg: u8,
        piBsbDom1PwdReg: u8,
        piBsbDom1PgsReg2: u8,
        initialClockRate: u32,
        bootAddressOffset: u32,
        releaseOffset: u32,
        crc1: u32,
        crc2: u32,
        unused1: u64,
        gameName: [20]u8,
        unused2: u32,
        developerId: u32,
        cartridgeId: u16,
        countryCode: u16,

        pub fn setup(comptime gameName: []const u8) Header {
            var header = Header{
                .piBsbDom1LatReg = 0x80,
                .piBsbDom1PgsReg = 0x37,
                .piBsbDom1PwdReg = 0x12,
                .piBsbDom1PgsReg2 = 0x40,
                .initialClockRate = 0x0,
                .bootAddressOffset = 0x80001000,
                .releaseOffset = 0x0,
                .crc1 = 0x0,
                .crc2 = 0x0,

                .gameName = [_]u8{' '} ** 20,
                .developerId = 0,
                .cartridgeId = 0,
                .countryCode = 0,

                .unused1 = 0,
                .unused2 = 0,
            };

            comptime {
                for (gameName) |value, index| {
                    var validChar = isUpper(value) or isDigit(value);

                    if (validChar and index < 20) {
                        header.gameName[index] = value;
                    } else {
                        if (index >= 20) {
                            @compileError("Game name is too long, it needs to be no longer than 20 characters.");
                        } else if (!validChar) {
                            @compileError("Game name needs to be in uppercase, it can use digits.");
                        }
                    }
                }
            }

            return header;
        }
    };
};

export nakedcc fn N64main() linksection(".n64main") noreturn {
    asm volatile (
        \\.set noat
        \\addiu $v0, $zero, 0x8
        \\lui $at, 0xBFC0
        \\sw $v0, 0x7FC($at)
    );

    // call user's main
    root.main();
}
