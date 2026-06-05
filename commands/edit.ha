use fmt;
use strings;
use os;
use engine;
use bufio;
use io;
use utils;
use settings;

export fn edit(id: u32) void = {
    let entry: engine::Entry = engine::readEntry(id);

    if(entry.status == engine::EntryStatus::NOTEXIST) {
        fmt::println("The entry id:", id, "not exist!")!;
        return;
    };

    fmt::println(entry.title)!;
    fmt::println(engine::statustostr(entry.status))!;
    fmt::println(utils::formatdate(entry.date))!;
    fmt::println(entry.description)!;

    let title: str = "";
    let description: str = "";

    fmt::print("Title: ")!;
    bufio::flush(os::stdout)!;
    let scanner = bufio::newscanner(os::stdin);

    for(title == "") {
        match(bufio::scan_line(&scanner)) {
            case let line: str => if(len(line) > 0){
                title = strings::dup(line)!;
            };
            case  => fmt::errorf("Erreur lors de la lecture\n",)!;
        };
    };
    bufio::finish(&scanner);

    fmt::print("\nDescription: ")!;
    bufio::flush(os::stdout)!;
    let scanner = bufio::newscanner(os::stdin);
    match(bufio::scan_line(&scanner)) {
        case let line: str => if(len(line) > 0){
            description = strings::dup(line)!;
        };
        case  => fmt::errorf("Erreur lors de la lecture\n",)!;
    };
    bufio::finish(&scanner);
    let editentry: engine::Entry = engine::newEntry(title, description);
    let data: []u8 = engine::editEntry(id, editentry);
    defer free(data);
    let file = os::create(settings::DATA_FILE, 0o644)!;
    defer io::close(file)!;

    io::write(file, data)!;
    fmt::println("\ntest de new adr: ", title)!;

};

// export fn edit(args: []str) void = {

//     let title: str = "";
//     let description: str = "";
//     if (len(args) < 3) {
//         fmt::print("Title: ")!;
//         bufio::flush(os::stdout)!;
//         let scanner = bufio::newscanner(os::stdin);
//         defer bufio::finish(&scanner);
//         for(title == "") {
//             match(bufio::scan_line(&scanner)) {
//                 case let line: str => if(len(line) > 0){
//                     title = strings::dup(line)!;
//                 };
//                 case  => fmt::errorf("Erreur lors de la lecture\n",)!;
//             };
//         };
//     }else{
//         title = strings::join(" ", args[2..]...)!;
//     };


//     fmt::print("\nDescription: ")!;
//     bufio::flush(os::stdout)!;
//     let scanner = bufio::newscanner(os::stdin);
//     match(bufio::scan_line(&scanner)) {
//         case let line: str => if(len(line) > 0){
//             description = strings::dup(line)!;
//         };
//         case  => fmt::errorf("Erreur lors de la lecture\n",)!;
//     };

//     bufio::finish(&scanner);
//     const vowDataPath = ".vow/data.vow";
//     let editentry: engine::Entry = engine::newEntry(title, description);
//     let data: []u8 = engine::editEntry(newtest);
//     defer free(data);
//     let file = os::create(vowDataPath, 0o644)!;
//     defer io::close(file)!;

//     io::write(file, data)!;
//     fmt::println("\ntest de new adr: ", title)!;

// };
