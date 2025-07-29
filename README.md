# vscode_backup_restore

Create a zip archive of the installed version of vscode (windows, linux and server binaries) + all the installed extensions, settings and configs.

Structure of the zip archive :

```plaintext
vscode_backup_<DATE>.zip
├── backup_<DATE>/
│   ├── extensions/
│   │   ├── ABC.vsix
│   │   └── XYZ.vsix
│   ├── extensions.txt
│   ├── keybindings.json
│   ├── restore_vscode.sh
│   ├── settings.json
│   ├── vscode_commit.txt
│   ├── vscode-linux-x64.deb
│   ├── vscode-server-linux-x64.tar.gz
│   └── vscode-win.exe
```

## `backup_vscode.sh`

download the current installed version of vscode, copy the linux restore script, download all the installed extensions, copy the vscode config files, and create a final zip

### backup script : environment variables

- `BACKUPS_FOLDER` : specify the backup destination folder, default to `${HOME}/.vscode/backups`

## `restore_vscode_linux.sh`

Only on linux, install vscode if missing, restore extensions and settings

### restore script : environment variables

- `SKIP_EXTENSIONS` : default to `0`
- `SKIP_CONFIG` : default to `0`

## Getting started

```bash
BACKUPS_FOLDER="/tmp" bash backup_vscode.sh
```

```bash
# cd into the backup folder
bash restore_vscode_linux.sh
```
