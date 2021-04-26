module main

import os
import term

#include <signal.h>

fn handler() {
	println('')
	exit(0)
}

fn main() {
	os.signal(2, handler)
	os.signal(1, handler)
	for {
		abvwd := term.colorize(term.bold, '$os.getwd()').replace('$os.home_dir()', '~')
		mut stdin := (os.input_opt('$abvwd\n➜ ') or {
			exit(1)
			panic('Exiting: $err')
			''
		}).split(' ')
		match stdin[0] {
			'cd' {
				os.chdir(stdin[1])
			}
			'clear' {
				term.clear()
			}
			'chmod' {
				if os.exists(stdin[2]) {
					os.chmod(stdin[2], ('0o' + stdin[1]).int())
				} else {
					println('chmod: error: path does not exist')
				}
			}
			'cp' {
				if os.exists(stdin[1]) {
					if os.exists(stdin[2]) {
						println('cp: error: destination path exists, use ocp to override')
					} else {
						os.cp(stdin[1], stdin[2]) ?
					}
				} else {
					println('cp: error: source path does not exist')
				}
			}
			'ocp' {
				if os.exists(stdin[1]) {
					os.cp(stdin[1], stdin[2]) ?
				} else {
					println('ocp: error: source path does not exist')
				}
			}
			'exit' {
				exit(0)
			}
			'help' {
				println('cd			Change to provided directory.
chmod			Change file/dir access attributes and permissions.
clear			Clears the screen.
cp			Copy source file/dir to destination.
echo			Print entered message.
exit			Exit the shell.
help			Displays this message.
ls			List all files and subdirectories in current directory.
mkd			Creates new directory.
ocp			Override existing destination for cp.
rm			Removes file.
rmd			Removes directory.')
			}
			'ls' {
				ls := os.ls('.') ?.join('    ')
				println(ls)
			}
			'mkd' {
				os.mkdir_all(stdin[1]) ?
			}
			'rm' {
				if os.exists(stdin[1]) {
					if os.is_dir(stdin[1]) {
						println("rm: error: cannot remove '" + stdin[1] + "': Is a directory")
					} else {
						os.rm(stdin[1]) ?
					}
				} else {
					println("rm: error: cannot remove'" + stdin[1] + "': Path does not exist")
				}
			}
			'rmd' {
				if os.exists(stdin[1]) {
					os.rmdir(stdin[1]) ?
				} else {
					println("rm: error: cannot remove'" + stdin[1] + "': Path does not exist")
				}
			}
			'echo' {
				stdin.delete(0)
				println(stdin.join(' '))
			}
			else {
				println('command not found: ' + stdin[0])
			}
		}
	}
	exit(0)
}
