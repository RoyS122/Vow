use fmt;
use os;
use commands;
use strconv;

export fn main() void = {

	if( len(os::args) < 2) {
	    fmt::println("Try . help to get list of usable commands !")!;
		return;
	};

	 switch (os::args[1]) {
	    case "help", "h" => {
			if(len(os::args) > 2) {
			    commands::help(os::args[2]);
				return;
			};
			commands::help();
		};
		case "init", "i" => commands::init();
		case "new", "n" => commands::new(os::args);
		case "status", "s" => commands::status();
		case "read", "r" => {

		    if(len(os::args) > 2) {
				match (strconv::stou32(os::args[2])) {
                    case let n: u32 =>
                       	commands::read(n);
                    case let err: strconv::error =>
                        fmt::printfln("Erreur lors de la conversion : {}", strconv::strerror(err))!;
                };

				return;
			};
			commands::help();
		};
		case "edit", "e" => {

		    if(len(os::args) > 2) {
				match (strconv::stou32(os::args[2])) {
                    case let n: u32 =>
                       	commands::edit(n);
                    case let err: strconv::error =>
                        fmt::printfln("Erreur lors de la conversion : {}", strconv::strerror(err))!;
                };

				return;
			};
			commands::help();
		};
		case => fmt::printfln("Unknown command: {} please use \"help\" to see list of usable commands", os::args[1])!;
	};

	return;
};
