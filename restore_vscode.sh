#!/bin/bash

# usage : first (and only) argument is the path to the zip backup file
if [ ! -d "${1}" ]; then
    echo "backup folder not found"
    exit 1
fi
BACKUP_FOLDER="${1}"

# structure of the zip backup file :
# code_XXX_amd64.deb
# extensions/*.vsix
# extensions.txt
# keybindings.json (optional)
# settings.json

echo "installing vscode"
if ! command -v "code" &> /dev/null; then
    echo "vscode is not installed"
    sudo dpkg -i "${BACKUP_FOLDER}"/code*.deb
fi

echo "restoring settings.json and keybindings.json"
cp "${BACKUP_FOLDER}/settings.json" "${BACKUP_FOLDER}/keybindings.json" "${HOME}/.vscode/" 2> /dev/null

echo "restoring extensions"
for ext in "${BACKUP_FOLDER}"/extensions/*.vsix; do
    code --install-extension "${ext}"
done
