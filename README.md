# mkex
Create an executable file with the chosen language's interpreter, and open it in an editor
# USAGE
```bash
mkex [OPTIONS] FILE
```
# DESCRIPTION
`mkex` will create `FILE` in either your current directory or in `PATH`, and
give it executable permissions. It will also add the interpreter line at the top
of the file so when it opens, you will automatically be given syntx highlighting
if it's available, and if `EDITOR` supports it. Lastly, `-I` will set the `IFS`
(internal field separator) to a newline if the language is shell. The file will
then open in `EDITOR`.
# ENVIRONMENTAL VARIALBES
If no `EDITOR` is passed as an argument, `mkex` will check your
`ENVIRONMENTAL VARIABLES` for either `$FCEDIT`, `$VISUAL`, or `$EDITOR` to be
set. If you don't know, you can set your default editor. The way to do so is to
add `export VISUAL=vim` (or whatever you prefer) to a blank line in your
`~/.bashrc`. NOTE: bash will always try to use `$FCEDIT`, `$VISUAL`, and
`$EDITOR` in that order, and therefor is the order `mkex` uses.
# CONFIGURATION FILES
`mkex` accepts a configuration file where you can set default variables. Create
a file in your home directory called `.mkexrc`. Available variables:
`lang=LANGUAGE`, `perms=PERMISSIONS`, `editor=EDITOR`, `env=true` (same as
passing the `-n` flag), `clobber=true `(same as passing the `-C` flag),
`setifs=true` (same as passing the `-I` flag). All boolean values are `false` by
default. Any variables set in the configuation file, if needed, can be
overwritten by flags when initiating the program.
# ENVIRONMENT
Deployable on any Unix-like environment.
# AUTHOR
Written by Evan Gray.
# REPORTING BUGS
To report bugs, please create an issue in the repository.
# COPYRIGHT
Copyright (C) 2017, Evan Gray.  All rights reserved.  There is NO WARRANTY, to
the extent permitted by law.

