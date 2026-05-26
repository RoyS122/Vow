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
    binary[cursor] = e.status: u8;
    cursor += 1;

    endian::leputu64(binary[cursor..cursor + 8], e.date: u64);
    cursor += 8;
    let title_bytes = strings::toutf8(e.title);
    for (let i: size = 0; i < len(title_bytes); i += 1) {
        binary[cursor] = title_bytes[i];
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
        binary[cursor] = desc_bytes[i];
        cursor += 1;
    };

    return binary;
};


export fn appendEntry(e: Entry) []u8 = {
    const vowDirPath = ".vow/data.vow";
    let filebytes: []u8 = utils::readfile(vowDirPath);
    let jrn: Journal = ByteToJournal(filebytes);
    let newEntry: []u8 = entryToBytes(e);
    defer free(newEntry);

    append(filebytes, newEntry...)!;


    endian::leputu32(filebytes[4..8], jrn.header.length + 1);

    return filebytes;
};

export fn readEntry(eid: u32) Entry = {
    const vowDirPath = ".vow/data.vow";
    let filebytes: []u8 = utils::readfile(vowDirPath);
    defer free(filebytes);
    let jrn: Journal = ByteToJournal(filebytes);

    if(eid > jrn.header.length) {
        return newEntry("", ""); // void cause of the non existance
    };

    let off: u32 = 0;

    let cursor: u64 = 12; // size of the header of vow journal

    for (let id: u32 = 0; id < eid; id += 1) {
        off = endian::legetu32(filebytes[cursor..cursor+4]);
        cursor += off;
    };
    off = endian::legetu32(filebytes[cursor..cursor+4]);
    cursor += 4;

    let titlesize: u8 = filebytes[cursor];
    cursor += 1;

    let relationslength: u8 = filebytes[cursor];
    cursor += 1;

    let status: EntryStatus = filebytes[cursor]: EntryStatus;
    cursor += 1;

    let date: i64 = endian::legetu64(filebytes[cursor..cursor+8]):i64;
    cursor += 8;

    let title: str = strings::fromutf8(filebytes[cursor..cursor+titlesize])!;
    cursor += titlesize;
    fmt::println("size total vs title size:", off, "vs", titlesize)!;
    fmt::println("title: ", title)!;

    let descriptionsize: u32 = off - 15 - titlesize;
    let description: str = strings::fromutf8(filebytes[cursor..cursor+descriptionsize])!;
    cursor += descriptionsize;

    fmt::println(description)!;
    // endian::legetiu32(filebytes)
    //
    return newEntry(title, description);
};
