use fmt;
use os;
use strings;
use fs;

export fn init(path: str = "") void = {
    if (path != "") {
        let err: (void | fs::error) = os::mkdir(path, 0o755);
        if (err is fs::error) {
            fmt::println("error:", fs::strerror(err as fs::error))!;
            return;
        };
    };

    if (!strings::hassuffix(path, "/") && path != "" ) {
        path = strings::concat(path, "/")!;
    }else{
        path = strings::dup(path)!;
    };

    defer free(path);
    const vowDirPath = strings::concat(path, ".vow")!;
    defer free(vowDirPath);
    let err: (void | fs::error) = os::mkdir(vowDirPath, 0o755);
    if (err is fs::error) {
        fmt::println("error:", fs::strerror(err as fs::error))!;
        return;
    };


    const vowDataPath = strings::concat(vowDirPath, "/data.vow")!;
    defer free(vowDataPath);


    let err: (void | fs::error) = os::mkfile(vowDataPath, 0o755);
    if (err is fs::error) {
        fmt::println("error:", fs::strerror(err as fs::error))!;
        return;
    };
};
