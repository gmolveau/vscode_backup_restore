#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Environment variables :
## RESTORE_EXTENSIONS, default to 1
## RESTORE_CONFIG, default to 1

echo "installing vscode"
if ! command -v "code" &> /dev/null; then
    echo "vscode is not installed"
    sudo dpkg -i "${__dir}"/vscode*.deb
fi

RESTORE_EXTENSIONS="${RESTORE_EXTENSIONS:-1}"
if [ "${RESTORE_EXTENSIONS}" == 1 ]; then
    echo "restoring extensions"
    for ext in "${__dir}"/extensions/*.vsix; do
        code --install-extension "${ext}"
    done
else
    echo "skipping extensions..."
fi

RESTORE_CONFIG="${RESTORE_CONFIG:-1}"
if [ "${RESTORE_CONFIG}" == 1 ]; then
    echo "restoring settings.json and keybindings.json"
    cp "${__dir}/settings.json" "${__dir}/keybindings.json" "${HOME}/.vscode/" 2> /dev/null
else
    echo "skipping config files..."
fi