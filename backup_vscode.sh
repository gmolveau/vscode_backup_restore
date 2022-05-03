#!/bin/bash

BACKUP_FOLDER="backup_$(date +'%Y-%m-%dT%H-%M-%S')"
BACKUP_PATH="$HOME/.vscode/$BACKUP_FOLDER"
mkdir -p "$BACKUP_PATH/extensions"

echo "download latest vscode"
cd "$BACKUP_PATH"
wget --content-disposition "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

echo "backup settings.json and keybindings.json"
CFG_FOLDER="$HOME/.config/Code/User/"
cp "$CFG_FOLDER/settings.json" "$CFG_FOLDER/keybindings.json" "$BACKUP_PATH" 2> /dev/null

echo "backup extensions"
code --list-extensions > "$BACKUP_PATH/extensions.txt"
cd "$BACKUP_PATH/extensions"
awk -F. '{print "wget -O "$1"."$2".vsix https://"$1".gallery.vsassets.io/_apis/public/gallery/publisher/"$1"/extension/"$2"/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"}' "$BACKUP_PATH/extensions.txt" | bash

echo "creating backup archive"
cd "$HOME/.vscode"
zip -r "vscode_$BACKUP_FOLDER.zip" "$BACKUP_FOLDER"

