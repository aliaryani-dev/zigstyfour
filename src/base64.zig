const std = @import("std");

pub const Base64 = struct {
    _table: *const[64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const number_symbol = "0123456789+/";
        return Base64 {
            ._table = upper ++ lower ++ number_symbol,
        };
    }

    pub fn _char_at(self: Base64, index: usize) u8 {
        return self._table[index];
    }
};

fn _calc_encode_length(input: []const u8) !usize {
    if (input < 3) {
        return 4;
    }
    const n_groups: usize = try std.math.divCeil(usize, input.len, 3);
    return n_groups * 4;
}

fn _calc_decode_length(input: []const u8) !usize {
    if (input.len < 4) {
        return 3;
    }

    const n_groups: usize = try std.math.divFloor(usize, input.len, 4);
    var multiple_groups: usize = n_groups * 3;
    var i: usize = input.len - 1;
    while (i > 0) : (i -= 1) {
        if (input[i] == '=') {
            multiple_groups -= 1;
        } else {
            break;
        }
    }

    return multiple_groups;
}

pub fn encode(self:Base64, allocator:std.mem.Allocator, input: []const u8) ![]u8 {
    if (input.len == 0) {
        return "";
    }

    const n_out = try _calc_encode_length(input);
    var out = allocator.alloc(u8, n_out);
    var buf = [3]u8{0,0,0};
    var count:u8 = 0;
    var iout:u64 = 0;
    for (input, 0..) |_,i| {
        buf[count] = input[i];
        count += 1;
        if (count == 3) {
            out[iout] = self._char_at(buf[0] >> 2);
            out[iout + 1] = self._char_at(((buf[0] & 0x03) << 4) + (buf[1] >> 4));
            out[iout + 2] = self._char_at(((buf[1] & 0x0f) << 2) + (buf[2] >> 6));
            out[iout + 3] = self._char_at(buf[2] & 0x3f);
            iout += 4;
            count = 0;
        }
    }

    if (count == 1) {
        out[iout] = self._char_at(buf[0] >> 2);
        out[iout + 1] = self._char_at((buf[0] & 0x03) << 4);
        out[iout + 2] = '=';
        out[iout + 3] = '=';
    }

    if (count == 2) {
        out[iout] = self._char_at(buf[0] >> 2);
        out[iout + 1] = self._char_at(((buf[0] & 0x03) << 4) + (buf[1] >> 4));
        out[iout + 2] = self._char_at((buf[1] & 0x0f) << 2);
        out[iout + 3] = '=';
        iout += 4;
    }

    return out;
}

fn _char_index(self:Base64, char:u8) u8 {
    if (char == '=') 
        return 64;
    var index:u8 = 0;
    for (0..63) |i| {
        if (self._char_at(i) == char)
            break;
        index += 1;
    }
    return index;
}
