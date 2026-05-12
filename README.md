
```                                           
,--------.       ,--.   ,--.                 ,--.   
'--.  .--',--.--.`--' ,-|  | ,---. ,--,--, ,-'  '-. 
   |  |   |  .--',--.' .-. || .-. :|      \'-.  .-' 
   |  |   |  |   |  |\ `-' |\   --.|  ||  |  |  |   
   `--'   `--'   `--' `---'  `----'`--''--'  `--'   
```

---

A minimal directory/file jump list for Bash, Zsh, and Fish.

## Features

| Command | Alias | Description |
|---------|-------|-------------|
| `jump <1-10>` | `-j` | Jump to the indexed directory or open the indexed file |
| `add [file]` | `-a` | Add a file, or the current directory if omitted |
| `edit` | `-e` | Open the jump list in `$EDITOR` |
| `list` | `-l` | Print the jump list |

## Hotkeys

| Key | Action |
|-----|--------|
| `Alt+1` … `Alt+9` | Jump to slots 1–9 |
| `Alt+0` | Jump to slot 10 |
| `Alt+A` | Add current directory |
| `Ctrl+E` | Edit jump list |

## Installation

### Bash / Zsh

Source `trident.sh` from your shell rc file:

```sh
source ~/path/to/trident.sh
```

Zsh completions require `compinit` to have run before sourcing (the default in most setups).

### Fish

Source `trident.fish` from `~/.config/fish/config.fish`:

```fish
source ~/path/to/trident.fish
```

Or copy it directly into `~/.config/fish/functions/trident.fish` and source it once to activate the key bindings and completions (they register at source time, not lazily):

```fish
source ~/.config/fish/functions/trident.fish
```

## Configuration

Set `TRIDENT_JUMP_FILE` to override the default cache path (`$XDG_CACHE_HOME/trident`, falling back to `~/.cache/trident`):

```sh
export TRIDENT_JUMP_FILE="$HOME/.config/trident/slots"
```
