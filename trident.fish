# ,--------.       ,--.   ,--.                 ,--.
# '--.  .--',--.--.`--' ,-|  | ,---. ,--,--, ,-'  '-.
#    |  |   |  .--',--.' .-. || .-. :|      \'-.  .-'
#    |  |   |  |   |  |\ `-' |\   --.|  ||  |  |  |
#    `--'   `--'   `--' `---'  `----'`--''--'  `--'

function trident
    if not set -q TRIDENT_JUMP_FILE
        if set -q XDG_CACHE_HOME
            set -gx TRIDENT_JUMP_FILE "$XDG_CACHE_HOME/trident"
        else
            set -gx TRIDENT_JUMP_FILE "$HOME/.cache/trident"
        end
        mkdir -p (dirname "$TRIDENT_JUMP_FILE")
    end
    set -l _version "1.0.1"

    switch $argv[1]
        case jump -j
            set -l entry (sed -n "$argv[2]p" "$TRIDENT_JUMP_FILE" 2>/dev/null)
            if test -d "$entry"
                cd "$entry"
            else if test -f "$entry"
                eval $EDITOR (string escape -- $entry)
            else
                echo "trident: slot $argv[2] is empty or path no longer exists." >&2
                return 1
            end

        case add -a
            if test (count $argv) -ge 2
                set -l file (pwd)/$argv[2]
                if test -f "$file"
                    echo "trident: adding file: $file"
                    echo "$file" >> "$TRIDENT_JUMP_FILE"
                else
                    echo "trident: file not found: $file" >&2
                    return 1
                end
            else
                set -l dir (pwd)/
                echo "trident: adding dir: $dir"
                echo "$dir" >> "$TRIDENT_JUMP_FILE"
            end

        case edit -e
            eval $EDITOR (string escape -- $TRIDENT_JUMP_FILE)

        case list -l
            cat "$TRIDENT_JUMP_FILE"

        case help --help -h
            echo "Usage: trident <command> [arguments]"
            echo "Commands:"
            echo "  jump, -j <1-10>  Jump to the indexed directory or file."
            echo "  add, -a [file]   Add the file, or current dir if omitted."
            echo "  edit, -e         Edit the jump list."
            echo "  list, -l         Print the jump list."
            echo "  help, -h         Show this message."
            echo "  version, -v      Show version."

        case version -v
            echo $_version

        case '*'
            echo "trident: unknown command '$argv[1]'. Use 'trident help' for usage." >&2
            return 1
    end
end

# ── Key bindings ──────────────────────────────────────────────────────────────
# Alt+1…9 → jump to slots 1-9; Alt+0 → slot 10; Alt+A → add cwd; Ctrl+E → edit
for _i in 1 2 3 4 5 6 7 8 9
    bind \e$_i "commandline -r 'trident jump $_i'; commandline -f execute"
end
bind \e0 "commandline -r 'trident jump 10'; commandline -f execute"
bind \ea "commandline -r 'trident add'; commandline -f execute"
bind \ce "commandline -r 'trident edit'; commandline -f execute"
set -e _i

# ── Completions ───────────────────────────────────────────────────────────────
set -l _trident_cmds jump -j add -a edit -e list -l help -h version -v
complete -c trident -f
complete -c trident -n "not __fish_seen_subcommand_from $_trident_cmds" \
    -a "$_trident_cmds"
complete -c trident -n '__fish_seen_subcommand_from add -a' -F
set -e _trident_cmds
