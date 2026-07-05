use fmt;
use settings;
use engine;

export fn help(command: str = "") void = {
    if (command != "") {
        PrintCommandDetail(command);
        return;
    };

    PrintCommandsList();
};
