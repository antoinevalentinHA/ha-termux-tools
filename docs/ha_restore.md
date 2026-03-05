# ha_restore — Documentation

Extract a Home Assistant backup archive and store the configuration files locally on your Android device — so you can browse, search, and edit them directly from Termux.

---

## What it actually does

This script does **not** interact with a running Home Assistant instance. It has no network component.

What it does:

1. Finds the most recent `.tar` backup file in your `Download/` folder
2. Validates it is a genuine Home Assistant backup
3. Extracts the outer archive, then the inner `homeassistant*.tar` archive
4. Places the resulting `data/` folder at `/storage/emulated/0/HA/data`
5. Asks for confirmation before overwriting any existing local copy
6. Renames the previous `HA/data/` with a timestamp instead of deleting it
7. Cleans up temporary files and confirms completion

The end result is your HA configuration available locally on the phone at `/storage/emulated/0/HA/data/`, ready to be searched with `ha_find_contexte`, edited in a text editor, or inspected manually.

---

## Typical workflow

```
HA instance (web UI)
       │
       │  export backup
       ▼
  backup.tar  (in Download/)
       │
       │  ha_restore.sh
       ▼
/storage/emulated/0/HA/data/   ← local copy of your config
       │
       │  ha_find_contexte.sh
       ▼
  search results
```

---

## How HA backups are structured

Home Assistant exports backups as a **double-wrapped tar archive**:

```
backup_name.tar                  ← outer archive (downloaded from HA UI)
└── homeassistant.tar.gz         ← inner archive
    └── data/                    ← your configuration files
        ├── configuration.yaml
        ├── automations.yaml
        ├── www/
        └── ...
```

The script handles both extraction levels automatically.

---

## Safety features

### No destructive `rm -rf`

Instead of deleting your existing local `data/` folder, the script **renames** it:

```
HA/data/  →  HA/data__before_restore__20250115_143201/
```

Your previous local copy is always preserved.

### Confirmation dialog

Before anything is moved, a dialog appears:

```
⚠️ Cette opération va remplacer HA/data.

Backup : backup_20250115.tar

Continuer ?
```

Tapping **Cancel** aborts immediately with no changes made.

### Multi-step validation

| Check | What it verifies |
|-------|-----------------|
| `.tar` file exists | At least one backup is present in `Download/` |
| Contains `homeassistant` | The `.tar` is a real HA backup |
| Inner archive found | Nested `homeassistant*.tar*` exists after first extraction |
| `data/` directory found | Second extraction produced the expected structure |
| `data/` not empty | Extracted folder actually contains files |

If any check fails, a dialog explains the problem and the script exits without modifying anything.

---

## Configuration

```bash
DOWNLOADS="/storage/emulated/0/Download"   # where to look for .tar backup files
HA_ROOT="/storage/emulated/0/HA"           # where to place the extracted data/
```

| Variable | Default | Description |
|----------|---------|-------------|
| `DOWNLOADS` | `/storage/emulated/0/Download` | Folder scanned for backup `.tar` files |
| `HA_ROOT` | `/storage/emulated/0/HA` | Parent folder where `data/` will be placed |

---

## Usage

### Step 1 — Export a backup from Home Assistant

In the HA web UI: **Settings → System → Backups → Create backup**. Download the `.tar` file to your phone's `Download/` folder.

### Step 2 — Run the script

```bash
./ha_restore.sh
```

The script picks the **most recently modified** `.tar` file in `Download/` automatically.

### Step 3 — Confirm the dialog

Review the backup filename and tap **OK** to proceed.

### Step 4 — Use the local copy

Your config files are now at `/storage/emulated/0/HA/data/`. You can:

- Search them with `ha_find_contexte.sh`
- Open and edit `.yaml` files in any text editor app
- Browse the folder structure with a file manager

---

## Dependencies

| Tool | Install |
|------|---------|
| `termux-dialog` | `pkg install termux-api` + Termux:API app |
| `tar` | included in Termux base |
| `find` | included in Termux base |

See [INSTALL.md](./INSTALL.md) for the full setup guide.

---

## Limitations

- Only processes the **most recent** `.tar` in `Download/` — to use a specific backup, remove or rename newer files first
- Old `data__before_restore__*` folders are not automatically cleaned up; remove them manually when no longer needed
- This does not push changes back to HA — editing files locally has no effect on your running instance unless you manually transfer them back
