#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Environment variables :
## SKIP_EXTENSIONS, default to 0
## SKIP_CONFIG, default to 0

echo "installing vscode"
sudo dpkg -i "${__dir}"/vscode*.deb

SKIP_EXTENSIONS="${SKIP_EXTENSIONS:-0}"
if [ "${SKIP_EXTENSIONS}" == 0 ]; then
    echo "skipping extensions..."
else
    echo "restoring extensions"
    for ext in "${__dir}"/extensions/*.vsix; do
        code --install-extension "${ext}"
    done
fi

SKIP_CONFIG="${SKIP_CONFIG:-0}"
if [ "${SKIP_CONFIG}" == 0 ]; then
    echo "skipping config files..."
else
    echo "restoring settings.json and keybindings.json"
    cp "${__dir}/settings.json" "${__dir}/keybindings.json" "${HOME}/.vscode/" 2> /dev/null
fi