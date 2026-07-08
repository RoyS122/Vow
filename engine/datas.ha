use fmt;
use time::date;
use utils;
use endian;
use strings;
use bytes;
use settings;
use os;
use io;

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
    let filebytes: []u8 = utils::readfile(settings::DATA_FILE);

    let jrn: Journal = ByteToJournal(filebytes);
    let newEntry: []u8 = entryToBytes(e);
    defer free(newEntry);

    append(filebytes, newEntry...)!;


    endian::leputu32(filebytes[4..8], jrn.header.length + 1);

    return filebytes;
};

export fn readEntry(eid: u32) Entry = {

    let filebytes: []u8 = utils::readfile(settings::DATA_FILE);
    defer free(filebytes);
    let jrn: Journal = ByteToJournal(filebytes);

    if(eid >= jrn.header.length) {
        return Entry{
                status=EntryStatus::NOTEXIST,
                ...
            }; // void cause of the non existance
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

    let title: str = strings::dup(strings::fromutf8(filebytes[cursor..cursor+titlesize])!)!;
    cursor += titlesize + relationslength * 5;

    let descriptionsize: u32 = off - 15 - titlesize;
    let description: str = strings::dup(strings::fromutf8(filebytes[cursor..cursor+descriptionsize])!)!;
    cursor += descriptionsize;

    return Entry{
        title = title,
        description = description,
        date = date,
        status = status,
        ...
    };
};

export fn getEntryList() []Entry = {

    let filebytes: []u8 = utils::readfile(settings::DATA_FILE);
    defer free(filebytes);

    let jrn: Journal = ByteToJournal(filebytes);
    let list: []Entry = alloc([Entry{...}...], jrn.header.length)!;
    let off: u32 = 0;

    let cursor: u64 = 12; // size of the header of vow journal

    for (let id: u32 = 0; id < jrn.header.length; id += 1) {
        off = endian::legetu32(filebytes[cursor..cursor+4]);
        cursor += 4;

        let titlesize: u8 = filebytes[cursor];
        cursor += 3;

        let date: i64 = endian::legetu64(filebytes[cursor..cursor+8]):i64;
        cursor += 8;

        let title: str = strings::dup(strings::fromutf8(filebytes[cursor..cursor+titlesize])!)!;
        cursor += titlesize;

        cursor += off - 15 - titlesize;
        list[id] = Entry{title = title, date = date, ...};
    };


    return list;
};

export fn editEntry(eid: u32, e: Entry) []u8 = {

    let filebytes: []u8 = utils::readfile(settings::DATA_FILE);
    defer free(filebytes);

    // let jrn: Journal = ByteToJournal(filebytes);

    let newEntry: []u8 = entryToBytes(e);
    defer free(newEntry);

    let cursor: u32 = 4 + 4 + 4; // Journal Header Size
    let esize: u32 = 0;
    for(let i: u32 = 0; i < eid; i += 1) {
        esize = endian::legetu32(filebytes[cursor..cursor + 4]);
        cursor += esize;
    };
    esize = endian::legetu32(filebytes[cursor..cursor + 4]);
    let lastingentries: []u8 = filebytes[cursor + esize..];

    let newfilebytes: []u8 = alloc([0: u8...], len(filebytes) + e.totalsize - esize)!;
    newfilebytes[0..cursor] = filebytes[0..cursor];
    newfilebytes[cursor..cursor + e.totalsize] = newEntry;
    cursor += e.totalsize;
    newfilebytes[cursor..] = lastingentries;


    return newfilebytes;
};

export fn statustostr(s: EntryStatus) str = {
    switch (s) {
    case EntryStatus::ACCEPTED => return "Accepted";
    case EntryStatus::PROPOSED => return "Proposed";
    case EntryStatus::REJECTED => return "Rejected";
    case EntryStatus::SUPERSEDED => return "Superseded";
    case =>
        return "Unknown";
    };
};

export fn editEntryStatus(id: u32, newStatus: EntryStatus) void = {
    let filebytes: []u8 = utils::readfile(settings::DATA_FILE);
    defer free(filebytes);

    let jrn: Journal = ByteToJournal(filebytes);

    if(id >= jrn.header.length) {
        return;
    };

    let cursor: u32 = 4 + 4 + 4; // Journal Header Size

    let esize: u32 = 0;
    for(let i: size = 0; i < id; i += 1) {
        esize = endian::legetu32(filebytes[cursor..cursor + 4]);
        cursor += esize;
    };

    cursor += 4 + 1 + 1;

    filebytes[cursor] = newStatus;

    let file = os::create(settings::DATA_FILE, 0o644)!;
    defer io::close(file)!;

    io::write(file, filebytes)!;
};

export fn addEntryRelation(entryA: u32, relation: Relation) u8 = {
    let filebytes: []u8 = utils::readfile(settings::DATA_FILE);
    defer free(filebytes);

    let journallength = endian::legetu32(filebytes[4..8]);

    if(entryA >= journallength) {
        return 1; // Not exist
    };

    if(entryA <= relation.id) {
        return 2; // Superseder must be higer than the superseded
    };

    let cursor: u32 = 4 + 4 + 4; // Journal Header Size

    let esize: u32 = 0;
    for(let i: size = 0; i < entryA; i += 1) {
        esize = endian::legetu32(filebytes[cursor..cursor + 4]);
        cursor += esize;
    };

    esize = endian::legetu32(filebytes[cursor..cursor + 4]);
    let lastingentries: []u8 = filebytes[cursor + esize..]; // split the last entries in new array

    cursor += 4; // Point at titlesize

    let etitlesize: u8 = filebytes[cursor];
    cursor += 1; // Point at relationlength

    let erelationslength: u8 = filebytes[cursor];
    cursor += 1; // Point at status

    cursor += 1 + 8 + (etitlesize : u32); // Skip status and date and title to related

    for(let i: size = 0; i < erelationslength; i += 1) {
        let relId = endian::legetu32(filebytes[cursor..cursor + 4]);
        cursor += 4;
        if(relId == relation.id) {
            if(relation.kind == filebytes[cursor]) {
                return 3; // Relation already present
            };
        };
        cursor += 1;
    };

    if(erelationslength >= 255) {
        return 4; // The relations of this record are already full
    };

    cursor -= erelationslength * 5; // back before the relations segment
    cursor -= (etitlesize : u32) + 8; // point at date
    cursor -= 1 + 1; // point at relationlength


    filebytes[cursor] += 1; // add 1 at relationlength
    cursor -= 1 + 4;// point at totalsize

    endian::leputu32(filebytes[cursor .. cursor+4], esize + 5);

    cursor += 4 + 1 + 1 + 1 + 8 + (etitlesize : u32) + 5 * (erelationslength : u32); //point at end of related


    let newfilebytes: []u8 = alloc([0: u8...], len(filebytes) + 5)!;
    newfilebytes[0..cursor] = filebytes[0..cursor];
    let lasting: []u8 = filebytes[cursor..];
    endian::leputu32(newfilebytes[cursor..cursor+4], relation.id);
    cursor += 4;
    newfilebytes[cursor] = relation.kind;
    cursor += 1;
    newfilebytes[cursor..] = lasting;


    let file = os::create(settings::DATA_FILE, 0o644)!;
    defer io::close(file)!;

    io::write(file, newfilebytes)!;

    return 0;
};
