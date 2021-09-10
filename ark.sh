#! /bin/bash

set -e

get_latest_release() {
  curl -s https://api.github.com/repos/arken/ark/releases/latest \
   | grep tag_name \
   | sed -E 's/.*"([^"]+)".*/\1/'
}

echo "Downloading Ark..."

os=$( echo "$(uname -s)" | tr -s  '[:upper:]'  '[:lower:]' )
arch=$( echo "$(uname -m)" | tr -s  '[:upper:]'  '[:lower:]' )
latest=$(get_latest_release)

if [ "$arch" = "x86_64" ]; then
        arch="amd64"
fi

exe=$HOME/.ark/bin

mkdir -p $exe

curl --fail --location --progress-bar --output $exe/ark https://github.com/arken/ark/releases/download/$latest/ark-$latest-$os-$arch
chmod a+x $exe/ark

echo "Ark was installed successfully to $exe"
if command -v ark >/dev/null; then
        echo "Run 'ark --help' to get started"
else
        case $SHELL in
        /bin/zsh) shell_profile=".zshrc" ;;
        *) shell_profile=".bash_profile" ;;
        esac
        echo "Manually add the directory to your \$HOME/$shell_profile (or similar)"
        echo
        echo "  export PATH=\"\$HOME/.ark/bin:\$PATH\""
        echo
        echo "Run '$exe --help' to get started"
fi
