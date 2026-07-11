export def DATA_FILE: str = ".vow/data.vow";
export def ENTRY_HEADER_FIXED_SIZE: u32 = 1 + 1 + 1 + 8; // 11 octets fixes
export def JOURNAL_HEADER_FIXED_SIZE: u32 = 4 + 4 + 2 + 2;
export def RELATION_FIXED_SIZE: u32 = 5;
