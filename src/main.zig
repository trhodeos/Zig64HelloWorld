const N64 = @import("n64.zig").N64;

export var gameHeader linksection(".n64header") = N64.Header.setup("HELLOWORLD", "AWJE", "00", 0);

pub fn main() noreturn {

    while (true) {}
}
