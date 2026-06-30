#!/usr/bin/env bash
set -euo pipefail

install_dir="$HOME/.local/bin"
bashrc="$HOME/.bashrc"
path_line='export PATH="$HOME/.local/bin:$PATH"'
marker_start='# >>> installplz >>>'
marker_end='# <<< installplz <<<'
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$install_dir"
cp "$script_dir/bin/installplz" "$install_dir/installplz"
chmod +x "$install_dir/installplz"
touch "$bashrc"

if ! grep -Fqx "$path_line" "$bashrc"; then
    printf '\n%s\n%s\n%s\n' "$marker_start" "$path_line" "$marker_end" >> "$bashrc"
fi

# Sourcing cannot change the parent shell, but it validates the updated file.
# shellcheck disable=SC1090
source "$bashrc" 2>/dev/null || true

cat <<'EOF'
installplz installed successfully!

Try:
  installplz app.deb
  installplz app.rpm
  installplz app.pkg.tar.zst
  installplz app.AppImage
  installplz installer.sh
  installplz source.tar.gz

Open a new Bash shell if the command is not available yet.
EOF
