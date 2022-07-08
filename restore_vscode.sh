#!/bin/bash

# usage : first (and only) argument is the path to the zip backup file
if [ ! -f "$1" ]; then
    echo "backup file not found"
    exit 1
fi

# structure of the zip backup file :
# code_XXX_amd64.deb
# extensions/*.vsix
# extensions.txt
# keybindings.json (optional)
# settings.json

WORKDIR="/tmp/$(date +'%Y-%m-%dT%H-%M-%S')"
mkdir -p "$WORKDIR"
echo "WORKDIR = $WORKDIR"
unzip $1 -d "$WORKDIR"

echo "installing vscode"
sudo dpkg -i "$WORKDIR"/code*.deb

echo "restoring settings.json and keybindings.json"
cp "$WORKDIR/settings.json" "$WORKDIR/keybindings.json" "$HOME/.vscode/" 2> /dev/null

echo "restoring extensions"
for ext in "$WORKDIR"/extensions/*.vsix; do
    code --install-extension "$ext"
done
