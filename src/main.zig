const Base64 = struct {
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
