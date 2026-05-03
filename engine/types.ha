use endian;
use types;

export type Entry = struct {
    totalsize: u32,
    titlesize: u8,
    relationssize: u8,
    status: EntryStatus,

    title: str,
    description: str,
    related: []Relation,
    date: i64,
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
    kind: RelationType,
    id: u32,
};
