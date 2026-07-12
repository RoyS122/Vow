use fmt;
use os;
use commands;
use strconv;
use utils;

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
		case "list", "l" => {
		    commands::list();
		};

		case "supersede", "su" => {
		    if (len(os::args) < 4) {
				return;
			};
			let old: u32 = utils::atouint(os::args[2]);
			let new: u32 = utils::atouint(os::args[3]);

			commands::supersede(old, new);
		};

		case "accept", "ac" => {
		    if (len(os::args) < 3) {
				return;
			};
			let id: u32 = utils::atouint(os::args[2]);

			commands::accept(id);
		};

		case "reject", "re" => {
		    if (len(os::args) < 3) {
				return;
			};
			let id: u32 = utils::atouint(os::args[2]);

			commands::reject(id);
		};

		case => fmt::printfln("Unknown command: {} please use \"help\" to see list of usable commands", os::args[1])!;
	};

	return;
};
