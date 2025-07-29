# vscode_backup_restore

- `backup_vscode.sh`

download the latest version of vscode, copy the restore script, download all the extensions, copy the vscode config files, and create a final zip

`BACKUPS_FOLDER` : specify the backup destination folder, default to `${HOME}/.vscode/backups`

- `restore_vscode.sh`

install vscode if missing, restore extensions and settings

## Getting started

```bash
BACKUPS_FOLDER=$(pwd) bash backup_vscode.sh
```

```bash
bash restore_vscode.sh vscode_backup_2025-04-01T12-12-00.zip
```
