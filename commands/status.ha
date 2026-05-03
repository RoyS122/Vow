use fmt;
use engine;
use os;
use io;
use fs;
use utils;

export fn status() void = {
    const vowDirPath = ".vow/data.vow";

    let filebytes: []u8 = utils::readfile(vowDirPath);
    defer free(filebytes);

    let journal: engine::Journal = engine::ByteToJournal(filebytes);
    fmt::printfln("Journal chargé avec succès !")!;
    fmt::printfln("Magic: {}{}{}{}",
        journal.header.magic[0]: rune,
        journal.header.magic[1]: rune,
        journal.header.magic[2]: rune,
        journal.header.magic[3]: rune)!;
    fmt::printfln("Version: {}.{}", journal.header.verMaj, journal.header.verMin)!;
    fmt::printfln("Nombre d'entrées: {}", journal.header.length)!;

};
