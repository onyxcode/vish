import os
import term

for {
	if 1 != 3 {
		abvwd := term.colorize(term.bold ,"$os.getwd()").replace("$os.home_dir()", "~")
		stdin := (os.input_opt("$abvwd\n> ") ?).split(" ")
		match stdin[0] {
			"cd" { os.chdir(stdin[1]) }
			"clear" { term.clear() }
			"exit" { exit(0) }
			"help" { println("cd		Change to provided directory.
clear		Clears the screen.
help		Displays this message.") }
			else { println(stdin[0] + ": command not found") }
		}

	}
}