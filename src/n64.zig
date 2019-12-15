const root = @import("root");
const isUpper = @import("std").ascii.isUpper;
const isDigit = @import("std").ascii.isDigit;

pub const N64 = struct {
    pub const Header = packed struct {
        piBsbDom1LatReg: u8,
        piBsbDom1PgsReg: u8,
        piBsbDom1PwdReg: u8,
        piBsbDom1PgsReg2: u8,
        initialClockRate: u16,
        bootAddressOffset: u16,
        releaseOffset: u16,
        crc1: u8,
        crc2: u8,
        unused1: u32,
        gameName: [27]u8,
        developerId: u8,
        cartridgeId: u8,
        unused2: u8,
        countryCode: u8,
        unused3: u8,

        pub fn setup(comptime gameName: []const u8) Header {
            var header = Header{
                .piBsbDom1LatReg = 0x80,
                .piBsbDom1PgsReg = 0x37,
                .piBsbDom1PwdReg = 0x12,
                .piBsbDom1PgsReg2 = 0x40,
                .initialClockRate = 0x0F,
                .bootAddressOffset = 0x0,
                .releaseOffset = 0x0,
                .crc1 = 0x0,
                .crc2 = 0x0,

                .gameName = [_]u8{' '} ** 27,
                .developerId = 0,
                .cartridgeId = 0,
                .countryCode = 0,

                .unused1 = 0,
                .unused2 = 0,
                .unused3 = 0,
            };

            comptime {
                for (gameName) |value, index| {
                    var validChar = isUpper(value) or isDigit(value);

                    if (validChar and index < 27) {
                        header.gameName[index] = value;
                    } else {
                        if (index >= 27) {
                            @compileError("Game name is too long, it needs to be no longer than 27 characters.");
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

export nakedcc fn n64Main() noreturn {
    asm volatile (
        \\.set noat
        \\addiu $v0, $zero, 0x8
        \\lui $at, 0xBFC0
        \\sw $v0, 0x7FC($at)
    );

    // call user's main
    root.main();
}
