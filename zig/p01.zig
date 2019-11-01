const warn = @import("std").debug.warn;

pub fn main() void {

    warn("你好世界 \n");

    const ts = Timestamp.unixEpoch();
    warn("{}", ts.sencods);
}

const Timestamp = struct {
    sencods: i64,
    nanos: u32,

    pub fn unixEpoch() Timestamp {
        return Timestamp {
            .sencods = 0,
            .nanos = 0,
        };
    }
};

