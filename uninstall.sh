#!/usr/bin/env bash
set -euo pipefail

bashrc="$HOME/.bashrc"
marker_start='# >>> installplz >>>'
path_line='export PATH="$HOME/.local/bin:$PATH"'
marker_end='# <<< installplz <<<'

rm -f "$HOME/.local/bin/installplz"

if [[ -f $bashrc ]]; then
    backup="$HOME/.bashrc.installplz-backup-$(date +%Y%m%d%H%M%S)-$$"
    temporary=$(mktemp "$HOME/.bashrc.installplz.XXXXXX")
    cp -p "$bashrc" "$backup"

    if awk -v start="$marker_start" -v path="$path_line" -v end="$marker_end" '
        { lines[NR] = $0 }
        END {
            for (i = 1; i <= NR; i++) {
                if (lines[i] == start && lines[i + 1] == path && lines[i + 2] == end) {
                    i += 2
                    removed = 1
                } else {
                    print lines[i]
                }
            }
            exit !removed
        }
    ' "$bashrc" > "$temporary"; then
        chmod --reference="$bashrc" "$temporary"
        mv "$temporary" "$bashrc"
        echo "Removed installplz settings from $bashrc"
    else
        rm -f "$temporary"
        echo "No installplz-managed settings found in $bashrc"
    fi

    echo "Bashrc backup: $backup"
fi

echo "installplz uninstalled successfully!"
