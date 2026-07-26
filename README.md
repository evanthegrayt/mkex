# mkex
This project is now read-only. I merged this functionality with my other
project, [exed](https://github.com/evanthegrayt/exed). I'll keep this project
for now, but I highly recommend using `exed`. This project is not guaranteed to
remain available in the future!

`mkex` provides an easy way to create a file and give it executable permissions.
It will also add the chosen language's interpreter line at the top of the file
so when it opens, you will automatically be given syntax highlighting if it's
available and your editor supports it. Lastly, `-I` will set the `IFS`
(internal field separator) to a newline if the language is `bash`, `sh`, or
`zsh`. The file will then open in your editor.

## Installation
Clone the repository, and `cd` into the base directory, and link the executable
into your path. Copy and paste:
```sh
git clone https://github.com/evanthegrayt/mkex.git
cd mkex
ln -s $PWD/bin/mkex /usr/local/bin/mkex
```

## Usage
Call the executable, passing it a language option and the name of the file you
wish to create:
```sh
mkex [OPTIONS] FILE
# For example, to create an executable `ruby` file, called "ruby_script", run
mkex -r ruby_script
```
Run with `-h` to see available options.

## Environment Variables
If no editor is passed with `-e`, `mkex` will check your environment for
`$FCEDIT`, `$VISUAL`, and `$EDITOR`, in that order. If none are set, it will
fall back to `vim`.

If you want to set a default editor, add something like this to your shell
configuration:

```sh
export VISUAL=vim
```

## Configuration Files
`mkex` accepts a configuration file where you can set default variables. Create
a file in your home directory called `.mkexrc`. Available variables:

- `lang=LANGUAGE`
- `perms=PERMISSIONS` (three-digit chmod-style permissions where the owner can
  execute, such as `755` or `700`)
- `editor=EDITOR`
- `env=true` (same as passing `-n`)
- `clobber=true` (same as passing `-C`)
- `setifs=true` (same as passing `-I`)
- `mode=clobber`, `mode=noclobber`, or `mode=interactive`

All boolean values are `false` by default. Any variables set in the
configuration file can be overwritten by flags when initiating the program. For
example, `-N` unsets a configured `env=true`, and `-O` restores the default
interactive overwrite prompt if clobbering is configured.

## Testing
Run the test suite with:

```sh
bats test
```

## Reporting Bugs
I did my best to fix any bugs before marking this repository read-only, but if
you find bugs, I recommend switching to
[exed](https://github.com/evanthegrayt/exed). The bug may already be fixed
there, but if not, [submit an
issue](https://github.com/evanthegrayt/exed/issues/new).

## Support this project
I love knowing when people find my work useful. Any kind of support is very much
appreciated!

- ⭐️ Like the project? Star [the repository](https://github.com/evanthegrayt/mkex)!
- ❤️ Love the project? Follow me [on GitHub](https://github.com/evanthegrayt)!
- 💸 *Really* love it? Consider [buying me a tea](https://paypal.me/evanrgray)!
