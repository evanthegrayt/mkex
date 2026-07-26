#!/usr/bin/env bats

setup() {
    REPO_ROOT=$(cd "$BATS_TEST_DIRNAME/.." && pwd)
    MKEX="$REPO_ROOT/bin/mkex"
    TEST_HOME="$BATS_TEST_TMPDIR/home"
    ENV_PATH=$(command -v env)
    BASH_PATH=$(command -v bash)

    mkdir -p "$TEST_HOME"
}

mkex() {
    HOME="$TEST_HOME" FCEDIT= VISUAL= EDITOR= "$MKEX" "$@" 2>&1
}

file_mode() {
    if stat -f %Lp "$1" >/dev/null 2>&1; then
        stat -f %Lp "$1"
    else
        stat -c %a "$1"
    fi
}

line_at() {
    sed -n "${1}p" "$2"
}

@test "script can be sourced without running main" {
    run bash -c 'source "$1"; print_usage; declare -p PROGRAM VERSION USAGE DEFAULT_PERMS IFS_LINE' _ "$MKEX"

    [ "$status" -eq 0 ]
    [[ $output == *"USAGE: mkex [OPTIONS...] FILE"* ]]
    [[ $output == *"declare -r PROGRAM"* ]]
    [[ $output == *"declare -r VERSION"* ]]
    [[ $output == *"declare -r USAGE"* ]]
    [[ $output == *"declare -r DEFAULT_PERMS"* ]]
    [[ $output == *"declare -r IFS_LINE"* ]]
}

@test "creates a bash executable with default permissions" {
    local file="$BATS_TEST_TMPDIR/bash-script"

    run mkex -e true -C -b "$file"

    [ "$status" -eq 0 ]
    [ "$(line_at 1 "$file")" = "#!$BASH_PATH" ]
    [ "$(file_mode "$file")" = "755" ]
}

@test "clobber option does not count as a language" {
    local file="$BATS_TEST_TMPDIR/clobber-script"

    run mkex -e true -C -b "$file"

    [ "$status" -eq 0 ]
    [ "$(line_at 1 "$file")" = "#!$BASH_PATH" ]
}

@test "k and K map to ksh and krsh" {
    local ksh_file="$BATS_TEST_TMPDIR/ksh-script"
    local krsh_file="$BATS_TEST_TMPDIR/krsh-script"

    run mkex -e true -C -n -k "$ksh_file"
    [ "$status" -eq 0 ]

    run mkex -e true -C -n -K "$krsh_file"
    [ "$status" -eq 0 ]

    [ "$(line_at 1 "$ksh_file")" = "#!$ENV_PATH ksh" ]
    [ "$(line_at 1 "$krsh_file")" = "#!$ENV_PATH krsh" ]
}

@test "interpreter options are separated from the shebang command" {
    local file="$BATS_TEST_TMPDIR/option-script"

    run mkex -e true -C -o -x -b "$file"

    [ "$status" -eq 0 ]
    [ "$(line_at 1 "$file")" = "#!$BASH_PATH -x" ]
}

@test "IFS line is written only for compatible shells" {
    local file="$BATS_TEST_TMPDIR/ifs-script"

    run mkex -e true -C -I -b "$file"

    [ "$status" -eq 0 ]
    [ "$(line_at 2 "$file")" = "IFS=\$'\\n'" ]
}

@test "IFS validation runs before interpreter resolution" {
    local file="$BATS_TEST_TMPDIR/fish-script"

    run mkex -e true -I -f "$file"

    [ "$status" -eq 1 ]
    [[ $output == *"'-I' is only compatible with bash, sh, and zsh"* ]]
    [[ $output != *"[fish] is not supported"* ]]
}

@test "no-clobber refuses existing files" {
    local file="$BATS_TEST_TMPDIR/existing-script"

    printf '%s\n' "already here" > "$file"
    run mkex -e true -B -b "$file"

    [ "$status" -eq 1 ]
    [[ $output == *"already exists and 'No-Clobber' is set"* ]]
    [ "$(line_at 1 "$file")" = "already here" ]
}

@test "configuration defaults are loaded from mkexrc" {
    local file="$BATS_TEST_TMPDIR/config-script"

    {
        printf '%s\n' "lang=bash"
        printf '%s\n' "editor=true"
        printf '%s\n' "perms=700"
        printf '%s\n' "env=true"
        printf '%s\n' "setifs=true"
        printf '%s\n' "mode=clobber"
    } > "$TEST_HOME/.mkexrc"

    run mkex "$file"

    [ "$status" -eq 0 ]
    [ "$(line_at 1 "$file")" = "#!$ENV_PATH bash" ]
    [ "$(line_at 2 "$file")" = "IFS=\$'\\n'" ]
    [ "$(file_mode "$file")" = "700" ]
}

@test "permissions must give the owner execute permission" {
    local private_file="$BATS_TEST_TMPDIR/private-script"
    local unusual_file="$BATS_TEST_TMPDIR/unusual-script"
    local non_executable_file="$BATS_TEST_TMPDIR/non-executable-script"

    run mkex -e true -C -E 700 -b "$private_file"
    [ "$status" -eq 0 ]
    [ "$(file_mode "$private_file")" = "700" ]

    run mkex -e true -C -E 577 -b "$unusual_file"
    [ "$status" -eq 0 ]
    [ "$(file_mode "$unusual_file")" = "577" ]

    run mkex -e true -C -E 644 -b "$non_executable_file"
    [ "$status" -eq 1 ]
    [[ $output == *"must give the owner execute permission"* ]]
    [ ! -e "$non_executable_file" ]
}

@test "explicit default assignment syntax is used instead of colon assignment" {
    run grep -F ': "${' "$MKEX"

    [ "$status" -eq 1 ]
}
