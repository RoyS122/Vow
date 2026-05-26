use fmt;
use os;
use io;
use fs;
use time;
use time::date;


export fn readfile(path: str) []u8 = {
    let file: (io::file | fs::error) = os::open(path);
    if (file is fs::error) {
        fmt::println("error:", fs::strerror(file as fs::error))!;
        return [];
    };
    defer io::close(file as io::file)!;

    let stat = os::fstat(file as io::file)!;

    let filebytes = alloc([0u8...], stat.sz)!;

    io::readall(file as io::file, filebytes)!;
    return filebytes;
};

export fn formatdate(ts: i64) str = {
    // 1. Créer un instant à partir de votre timestamp (i64)
    let instant = time::instant { sec = ts, nsec = 0 };

    // 2. Convertir cet instant en une date typée (locality UTC ou LOCAL)
    let d = date::from_instant(date::LOCAL, instant);

    // 3. Formater la date en string (n'oubliez pas de libérer la mémoire !)
    return date::asformat(date::STAMP, &d)!;
};
