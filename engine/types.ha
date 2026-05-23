use endian;


export type Entry = struct {
    totalsize: u32,
    titlesize: u8,
    relationslength: u8,
    status: EntryStatus,
    date: i64,

    title: str,
    related: []Relation,
    description: str,
};

export type Journal = struct {
    header: JournalHeader,
    entries: []Entry,
};
export type JournalHeader =  struct {
    magic: [4]u8,
    length: u32,
    verMaj: u16,
    verMin: u16,
};

export type EntryStatus = enum u8 {
    PROPOSED = 0,
    ACCEPTED = 1,
    REJECTED = 2,
    SUPERSEDED = 3,
};

export type RelationType = enum u8 {
    SUPERSEDE = 0,
    DEPENDS = 1,
 };

export type Relation = struct {
    id: u32,
    kind: RelationType,
};
