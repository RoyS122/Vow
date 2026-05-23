use endian;
use bytes;
use types;
use utils;
export fn JournalToByte(jrn: Journal) []u8 = {
    let headersize: u64 = size(JournalHeader);
    let entriessize: u64 = 0;

    for (let i: size = 0; i < len(jrn.entries); i += 1) {
        entriessize = entriessize + jrn.entries[i].totalsize;
    };

    let totalsize: u64 = headersize + entriessize;

    let binary  = alloc([0u8...], totalsize)!;


    let cursor: size = 0;
    // HEADER WRITING
    for (let i: size = 0; i < len(jrn.header.magic); i += 1) {
        binary[cursor] = jrn.header.magic[i];
        cursor += 1;
    };

    endian::leputu32(binary[cursor..cursor + 4], jrn.header.length);
    cursor += 4;

    endian::leputu16(binary[cursor..cursor + 2], jrn.header.verMaj);
    cursor += 2;

    endian::leputu16(binary[cursor..cursor + 2], jrn.header.verMin);
    cursor += 2;

    // END HEADER WRITING
    return binary;
};

export fn ByteToJournal(bytes: []u8) Journal = {
    let journal: Journal = Journal {
        header = JournalHeader {
            magic  = ['V', 'O', 'W', '!'],
            length = 0,
            verMaj = 0,
            verMin = 0,
        },
        entries = [],
    };

    let cursor: size = 0;
    if (! bytes::equal(bytes[cursor..cursor + 4], journal.header.magic))  {
        return journal;
    };
    cursor += 4;

    journal.header.length = endian::legetu32(bytes[cursor..cursor+4]);
    cursor += 4;

    journal.header.verMaj = endian::legetu16(bytes[cursor..cursor+2]);
    cursor += 2;

    journal.header.verMin = endian::legetu16(bytes[cursor..cursor+2]);
    cursor += 2;

    return journal;
};

export fn NewJournal() Journal =  {
    return  Journal {
        header = JournalHeader {
            magic = ['V', 'O', 'W', '!'],
            length = 0,
            verMaj = 0,
            verMin = 1,
        },
        entries = [],
    };
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
