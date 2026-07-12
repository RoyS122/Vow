use engine;
use fmt;

export const COMMANDS_LIST: [11]engine::Command = [
    engine::Command {
        title = "help",
        desc = "Display the list of commands or the detail of a command.",
        usage = `help {command name} / h {command name}`,
        exemples = [("help", "Get the list of command"), ("help help", "this page"), ("help init", "the \"init\" help page"), ("h edit", "the \"edit\" help page")],
    },

    engine::Command {
           title = "init",
           desc = "Initialise the journal in the current directory",
           usage = `init / i`,
           exemples = [("init", "Create .vow folder in current directory with the datas of the journal."), ("i", "Create .vow folder in current directory with the datas of the journal.")],
    },

    engine::Command {
        title = "status",
        desc = "Display status of a Vow journal.",
        usage = `status / s`,
        exemples = [("status", "Get the version of the journal and the ammount of entries"), ("s", "Get the version of the journal and the ammount of entries")],
    },
    engine::Command {
        title = "read",
        desc = "Read the entry of the journal at the given index.",
        usage = `read [id of the entry] / r [id of the entry]`,
        exemples = [("read", "Get this page probably"), ("read 3", "Get the entry at index 3"), ("read 0", "Get the entry at index 0"), ("r 1", "Get the entry at index 1")],
    },

    engine::Command {
        title = "new",
        desc = "Register a new entry in the journal.",
        usage = `new {title} / n {title}`,
        exemples = [("new", "Get form to register a new entry."), ("new entry title exemple", "Get the form to register a new entry starting at description field (title already filled)"), ("n", "Get form to register a new entry.")],
    },
    engine::Command {
        title = "edit",
        desc = "Allow to rewritte the content of the entry at the given index.",
        usage = `edit [entry id] / e [entry id]`,
        exemples = [("edit", "Get the help page of this command"), ("edit 1", "Edit the entry at index 1"), ("e 2", "Edit the entry at index 2")],
    },
    engine::Command {
        title = "list",
        desc = "Display list of the entries of a Vow journal. ( Id / Title / Date )",
        usage = `list / l`,
        exemples = [("list", "Display list of the entries."), ("l", "Display list of the entries.")],
    },
    engine::Command {
        title = "accept",
        desc = "Set status of a vow as accepted.",
        usage = `accept [id] / ac [id]`,
        exemples = [("accept 1", "Set the status of the entry index 1 as accepted."), ("ac 3", "Change status of the index 3 as accepted.")],
    },
    engine::Command {
        title = "reject",
        desc = "Set status of a vow as rejected.",
        usage = `reject [id] / re [id]`,
        exemples = [("reject 1", "Set the status of the entry index 1 as rejected."), ("re 3", "Change status of the index 3 as rejected.")],
    },
    engine::Command {
        title = "supersede",
        desc = "Set status of a vow as supersede and add the relations to concerned entries.",
        usage = `supersede [id old] [id new] / su [id old] [id new]`,
        exemples = [("supersede 0 1", "Set the status of entry 0 on superseded and add the relation of the entry index 1."), ("su 1 3", "Set the status of entry 0 on superseded and add the relation of the entry index 1.")],
    },
    engine::Command {
        title = "depends",
        desc = "Add the relations of dependance.",
        usage = `depends [id] [id dependance] / de [id] [id dependance]`,
        exemples = [("depends 1 0", "Add the relation depends on the entry 0 in the entry index 1."), ("de 3 1", "Add the relation depends on the entry 1 in the entry index 3.")],
    },
];

export fn PrintCommandsList() void = {
    fmt::println("List of all differents commands:")!;
    fmt::println("-----------------------------------------------------------\n")!;
    for(let i: size = 0; i < len(COMMANDS_LIST); i +=1 ) {
        const c: engine::Command = COMMANDS_LIST[i];
        fmt::println(c.title, ":", c.desc)!;
    };
};

export fn PrintCommandDetail(arg: str) void = {
    let c: engine::Command = engine::Command{...};

    for( let i: size = 0; i < len(COMMANDS_LIST); i +=1 ) {
        const check_command: engine::Command = COMMANDS_LIST[i];
        if(check_command.title == arg) {
            c = check_command;
        };
    };

    fmt::println(c.title, "details :\n-----------------------------------------------------------")!;
    fmt::println("Description :", c.desc)!;
    fmt::println("Usage :", c.usage)!;
    fmt::println("Exemples :\n-------------------- command -> expected output --------------------")!;
    for(let i: size = 0; i < len(c.exemples); i +=1 ) {
        const e: (str, str) = c.exemples[i];
        fmt::println(e.0, "->", e.1)!;
    };
};
