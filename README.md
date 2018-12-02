# mkex
`mkex` provides an easy way to create a file and give it executable permissions.
It will also add the chosen language's interpreter line at the top
of the file so when it opens, you will automatically be given syntx highlighting
if it's available, and if `EDITOR` supports it. Lastly, `-I` will set the `IFS`
(internal field separator) to a newline if the language is shell. The file will
then open in `EDITOR`.

## Installation
Clone the repository, and `cd` into the base directory, and link the executable
into your path. Copy and paste:
```sh
git clone https://github.com/evanthegrayt/mkex.git
cd mkex
ln -s $PWD/bin/mkex /usr/local/bin/mkex
```

## Usage
Call the executable, passing it a language option, and the name of the file you
wish to create.
```sh
mkex [OPTIONS] FILE
# For example, to create an executable `ruby` file, called "ruby_script", run
mkex -r ruby_script
```
Run with `-h` to see available options.

## Environmental Varialbes
If no `EDITOR` is passed as an argument, `mkex` will check your
`ENVIRONMENTAL VARIABLES` for either `$FCEDIT`, `$VISUAL`, or `$EDITOR` to be
set. If you don't know, you can set your default editor. The way to do so is to
add `export VISUAL=vim` (or whatever you prefer) to a blank line in your
`~/.bashrc`. NOTE: `bash` will always try to use `$FCEDIT`, `$VISUAL`, and
`$EDITOR` in that order, and therefor is the order `mkex` uses.

## Configuration Files
`mkex` accepts a configuration file where you can set default variables. Create
a file in your home directory called `.mkexrc`. Available variables:
`lang=LANGUAGE`, `perms=PERMISSIONS`, `editor=EDITOR`, `env=true` (same as
passing the `-n` flag), `clobber=true `(same as passing the `-C` flag),
`setifs=true` (same as passing the `-I` flag). All boolean values are `false` by
default. Any variables set in the configuation file, if needed, can be
overwritten by flags when initiating the program.

## Reporting Bugs
To report bugs, please create an issue in the repository.

