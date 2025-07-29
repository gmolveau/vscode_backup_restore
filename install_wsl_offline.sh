commit_id="<CHANGE_ME>"
mkdir -p "${HOME}/.vscode-server/bin/${commit_id}"
tar zxvf vscode-server-linux-x64.tar.gz -C "${HOME}/.vscode-server/bin/${commit_id}" --strip 1
touch "${HOME}/.vscode-server/bin/${commit_id}/0"
