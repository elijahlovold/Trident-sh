# ,--------.       ,--.   ,--.                 ,--.
# '--.  .--',--.--.`--' ,-|  | ,---. ,--,--, ,-'  '-.
#    |  |   |  .--',--.' .-. || .-. :|      \'-.  .-'
#    |  |   |  |   |  |\ `-' |\   --.|  ||  |  |  |
#    `--'   `--'   `--' `---'  `----'`--''--'  `--'

trident() {
    if [ -z "$TRIDENT_JUMP_FILE" ]; then
        TRIDENT_JUMP_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/trident"
        mkdir -p "$(dirname "$TRIDENT_JUMP_FILE")"
    fi
    local version="1.0.1"

    case "$1" in
        jump|-j)
            local dir
            dir=$(sed -n "${2}p" "$TRIDENT_JUMP_FILE" 2>/dev/null)
            if [ -d "$dir" ]; then
                cd "$dir"
            elif [ -f "$dir" ]; then
                "$EDITOR" "$dir"
            else
                echo "trident: slot $2 is empty or path no longer exists." >&2
                return 1
            fi
            ;;
        add|-a)
            if [ -n "$2" ]; then
                local file="$(pwd)/$2"
                if [ -f "$file" ]; then
                    echo "trident: adding file: $file"
                    echo "$file" >> "$TRIDENT_JUMP_FILE"
                else
                    echo "trident: file not found: $file" >&2
                    return 1
                fi
            else
                echo "trident: adding dir: $(pwd)/"
                echo "$(pwd)/" >> "$TRIDENT_JUMP_FILE"
            fi
            ;;
        edit|-e)
            "$EDITOR" "$TRIDENT_JUMP_FILE"
            ;;
        list|-l)
            cat "$TRIDENT_JUMP_FILE"
            ;;
        help|--help|-h)
            echo "Usage: trident <command> [arguments]"
            echo "Commands:"
            echo "  jump, -j <1-10>  Jump to the indexed directory or file."
            echo "  add, -a [file]   Add the file, or current dir if omitted."
            echo "  edit, -e         Edit the jump list."
            echo "  list, -l         Print the jump list."
            echo "  help, -h         Show this message."
            echo "  version, -v      Show version."
            ;;
        version|-v)
            echo "$version"
            ;;
        *)
            echo "trident: unknown command '$1'. Use 'trident help' for usage." >&2
            return 1
            ;;
    esac
}

# ── Bash ──────────────────────────────────────────────────────────────────────
if [[ -n "$BASH_VERSION" ]]; then

    _trident_completions() {
        local cur prev
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"

        if [[ $COMP_CWORD -eq 1 ]]; then
            COMPREPLY=( $(compgen -W "jump -j add -a edit -e list -l help -h version -v" -- "$cur") )
        elif [[ "$prev" == "add" || "$prev" == "-a" ]]; then
            COMPREPLY=( $(compgen -f -- "$cur") )
        fi
    }
    complete -F _trident_completions trident

    bind '"\e1":"\C-utrident jump 1\n"'
    bind '"\e2":"\C-utrident jump 2\n"'
    bind '"\e3":"\C-utrident jump 3\n"'
    bind '"\e4":"\C-utrident jump 4\n"'
    bind '"\e5":"\C-utrident jump 5\n"'
    bind '"\e6":"\C-utrident jump 6\n"'
    bind '"\e7":"\C-utrident jump 7\n"'
    bind '"\e8":"\C-utrident jump 8\n"'
    bind '"\e9":"\C-utrident jump 9\n"'
    bind '"\e0":"\C-utrident jump 10\n"'
    bind '"\ea":"\C-utrident add\n"'
    bind -x '"\C-e":trident edit'

# ── Zsh ───────────────────────────────────────────────────────────────────────
elif [[ -n "$ZSH_VERSION" ]]; then

    _trident() {
        local state
        local -a commands
        commands=(
            'jump:jump to indexed directory or file'
            '-j:jump to indexed directory or file'
            'add:add current directory or a file'
            '-a:add current directory or a file'
            'edit:open jump list in $EDITOR'
            '-e:open jump list in $EDITOR'
            'list:print jump list'
            '-l:print jump list'
            'help:show help'
            '-h:show help'
            'version:show version'
            '-v:show version'
        )
        _arguments \
            '1:command:->command' \
            '*:args:->args'
        case $state in
            command) _describe 'command' commands ;;
            args)
                case $words[2] in
                    add|-a)  _files ;;
                    jump|-j) _message 'slot (1-10)' ;;
                esac
                ;;
        esac
    }
    # requires compinit to have been run
    (( $+functions[compdef] )) && compdef _trident trident

    bindkey -s '^[1' '^Utrident jump 1\n'
    bindkey -s '^[2' '^Utrident jump 2\n'
    bindkey -s '^[3' '^Utrident jump 3\n'
    bindkey -s '^[4' '^Utrident jump 4\n'
    bindkey -s '^[5' '^Utrident jump 5\n'
    bindkey -s '^[6' '^Utrident jump 6\n'
    bindkey -s '^[7' '^Utrident jump 7\n'
    bindkey -s '^[8' '^Utrident jump 8\n'
    bindkey -s '^[9' '^Utrident jump 9\n'
    bindkey -s '^[0' '^Utrident jump 10\n'
    bindkey -s '^[a' '^Utrident add\n'
    bindkey -s '^e'  '^Utrident edit\n'

fi
