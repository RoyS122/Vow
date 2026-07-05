use engine;
use fmt;
use utils;
export fn list() void = {
    fmt::println("List of all differents entries:")!;
    fmt::println("-----------------------------------------------------------\n")!;

    let l: []engine::Entry = engine::getEntryList();
    defer free(l);
    for(let i: size = 0; i < len(l); i +=1 ) {
        const e: engine::Entry = l[i];
        fmt::println(i, "|", e.title, "|", utils::formatdate(e.date))!;
    };
};
