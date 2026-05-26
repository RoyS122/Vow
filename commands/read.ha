use fmt;
use engine;
use os;
use io;
use fs;
use utils;
use time;

export fn read(id: u32) void = {
    let entry: engine::Entry = engine::readEntry(id);

    if(entry.status == engine::EntryStatus::NOTEXIST) {
        fmt::println("The entry id:", id, "not exist!")!;
        return;
    };

    fmt::println(entry.title)!;
    fmt::println(engine::statustostr(entry.status))!;
    fmt::println(utils::formatdate(entry.date))!;
    fmt::println(entry.description)!;
};
