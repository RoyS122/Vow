use fmt;
use os;
use commands;
export fn main() void = {

	if( len(os::args) < 2) {
	    fmt::println("Try . help to get list of usable commands !")!;
		return;
	};

	 switch (os::args[1]) {
	    case "help", "h" => {
			if(len(os::args) > 1) {
			    commands::help(os::args[2]);
				return;
			};
			commands::help();
		};
		case "init", "i" => commands::init();
		case "new", "n" => commands::new();
		case => fmt::printfln("Unknown command: {} please use \"help\" to see list of usable commands", os::args[1])!;
	};

	return;
};
