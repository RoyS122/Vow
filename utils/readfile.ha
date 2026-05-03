use fmt;
use os;
use io;
use fs;


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
