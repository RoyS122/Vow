use fmt;
export fn help(command: str = "") void = {
    if (command != "") {
        fmt::println("help asked for", command)!;
        return;
    };
    fmt::println("help general asked")!;
};
