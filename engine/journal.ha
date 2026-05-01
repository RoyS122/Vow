export fn JournalToByte(jrn: Journal) []u8 {
    let headersize: u64 = size(jrn);
    let entriessize: u64 = 0;
    for ( let i: u32 = 0; i < jrn.length; i ++) {
        entriessize = entriessize + jrn.entries[i].totalsize;
    };

    let totalsize: u64 = headersize + entriessize;

};


export fn NewJournal() Journal {
    return  Journal {
        header = struct {
            magic = ['V', 'O', 'W', '!'],
            length = 0,
            verMaj = 0,
            verMin = 1,
        },
        entries = [],
    };
};
