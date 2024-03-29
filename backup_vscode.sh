#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

missing=0
for app in awk wget; do
    ! command -v ${app} &> /dev/null && echo "$name is not installed" && missing=1
done
[[ $missing -ne 0 ]] && exit 1

function clean_up() {
    echo ""
    echo ">>> cleaning up..."
    [ -d "$BACKUP_PATH" ] && rm -rf "$BACKUP_PATH"
}
trap clean_up EXIT

function clean_on_error() {
    ARG=$?
    echo ""
    echo ">>> error #$ARG - cleaning up..."
    [ -f "$BACKUP_ARCHIVE_PATH" ] && rm "$BACKUP_ARCHIVE_PATH"
    exit $ARG
}
trap clean_on_error ERR SIGINT

BACKUPS_FOLDER="$HOME/.vscode/backups"
BACKUP_FOLDER="backup_$(date +'%Y-%m-%dT%H-%M-%S')"
BACKUP_PATH="$BACKUPS_FOLDER/$BACKUP_FOLDER"
BACKUP_ARCHIVE="vscode_$BACKUP_FOLDER.zip"
BACKUP_ARCHIVE_PATH="$HOME/.vscode/$BACKUP_ARCHIVE"
mkdir -p "$BACKUP_PATH/extensions"

echo "> add restore script"
cp restore_vscode.sh "$BACKUPS_FOLDER/"

echo "> download latest vscode"
cd "$BACKUP_PATH"
wget -q --show-progress --content-disposition "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
# wget -q --show-progress --content-disposition "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
# wget -q --show-progress --content-disposition "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal"

echo "> backup settings.json and keybindings.json"
CFG_FOLDER="$HOME/.config/Code/User/"
[[ -e "$CFG_FOLDER/settings.json" ]] && cp "$CFG_FOLDER/settings.json" "$BACKUP_PATH"
[[ -e "$CFG_FOLDER/keybindings.json" ]] && cp "$CFG_FOLDER/keybindings.json" "$BACKUP_PATH"

echo "> backup extensions"
code --list-extensions > "$BACKUP_PATH/extensions.txt"
cd "$BACKUP_PATH/extensions"
awk -F. 'NF > 0 {print "wget -q --show-progress -O "$1"."$2".vsix https://"$1".gallery.vsassets.io/_apis/public/gallery/publisher/"$1"/extension/"$2"/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"}' "$BACKUP_PATH/extensions.txt" | bash

echo "> creating backup archive"
cd "$BACKUPS_FOLDER"
zip -q -r "$BACKUP_ARCHIVE" "$BACKUP_FOLDER"

echo "> done : $BACKUP_ARCHIVE_PATH"
exit 0
