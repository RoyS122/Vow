use fmt;
use time::date;
use utils;
use endian;
use strings;
use bytes;

export fn newEntry(title: str, description: str, status: EntryStatus = EntryStatus::PROPOSED, rels: []Relation = []) Entry = {

    // total size = size of the title + size of description + size of the relations section + header size

    let relLen: u8 = len(rels): u8;
    let totalSize: u32 = (len(title) + len(description) + len(rels) * 5 + 15): u32;
    let titleSize: u8 = len(title): u8;

    return Entry {
        totalsize = totalSize,
        titlesize = titleSize,
        relationslength = len(rels): u8,
        status = status,
        date =  date::now().sec,

        title = title,
        related = rels,
        description = description,
        };
};

export fn entryToBytes(e: Entry) []u8 = {
    let binary  = alloc([0u8...], e.totalsize)!;
    let cursor: u32 = 0;

    endian::leputu32(binary[cursor..cursor + 4], e.totalsize);
    cursor += 4;
    binary[cursor] = e.titlesize;
    cursor += 1;
     binary[cursor] = e.relationslength;
    cursor += 1;
    endian::leputu64(binary[cursor..cursor + 8], e.date: u64);
    cursor += 8;
    let title_bytes = strings::toutf8(e.title);
    for (let i: size = 0; i < len(title_bytes); i += 1) {
        binary[cursor] = title_bytes[0];
        cursor += 1;
    };


    for(let r_id: size = 0; r_id < e.relationslength; r_id += 1) {
        endian::leputu32(binary[cursor..cursor + 4], e.related[r_id].id);
        cursor += 4;
        binary[cursor] = e.related[r_id].kind;
        cursor += 1;
    };

    let desc_bytes = strings::toutf8(e.description);
    for (let i: size = 0; i < len(desc_bytes); i += 1) {
        binary[cursor] = desc_bytes[0];
        cursor += 1;
    };

    return binary;
};
