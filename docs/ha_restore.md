# ha_restore

Extract a Home Assistant backup archive and store the configuration files locally on your Android device.

---

## Purpose

This script does **not** interact with a running Home Assistant instance. It has no network component.

It extracts a `.tar` backup exported from the HA UI and places the `data/` folder at `/storage/emulated/0/HA/data/` on the phone — creating a **local mirror of your HA configuration** that can then be searched with `ha_find_contexte`.

---

## Typical workflow

```
Home Assistant (web UI)
      │
      │  export backup
      ▼
backup.tar  (Download/)
      │
      │  ha_restore.sh
      ▼
/storage/emulated/0/HA/data/   ← local mirror
      │
      │  ha_find_contexte.sh
      ▼
search results
```

---

## How HA backups are structured

Home Assistant exports backups as a double-wrapped tar archive:

```
backup.tar                       ← outer archive (downloaded from HA UI)
└── homeassistant.tar.gz         ← inner archive
    └── data/                    ← your configuration files
        ├── configuration.yaml
        ├── automations.yaml
        └── ...
```

The script handles both extraction levels automatically.

---

## Usage

### Step 1 — Export a backup from Home Assistant

In the HA web UI: **Settings → System → Backups → Create backup**.
Download the `.tar` file to your phone's `Download/` folder.

### Step 2 — Run the script

```bash
scripts/ha_restore.sh
```

The script automatically picks the most recently modified `.tar` file in `Download/`.
The script selects the newest file by modification time (ls -t)

### Step 3 — Confirm the dialog

Review the backup filename shown in the dialog and tap **OK** to proceed.

### Step 4 — Use the local mirror

Your config files are now at `/storage/emulated/0/HA/data/`. You can:

- Search them with `ha_find_contexte.sh`
- Open and edit `.yaml` files in any text editor
- Browse the folder structure with a file manager

---

## Safety features

### No destructive deletion

Instead of deleting the existing `data/` folder, the script renames it:

```
HA/data/  →  HA/data__before_restore__20250115_143201/
```

Your previous local mirror is always preserved.

### Confirmation dialog

Before any file is moved, a dialog appears showing the backup filename. Tapping **Cancel** aborts the script immediately with no changes made.

### Multi-step validation

| Check | What it verifies |
|-------|-----------------|
| `.tar` exists | At least one backup is present in `Download/` |
| Contains `homeassistant` | The file is a real HA backup |
| Inner archive found | Nested `homeassistant*.tar*` exists after first extraction |
| `data/` directory found | Second extraction produced the expected structure |
| `data/` not empty | Extracted folder contains files |

---

## Configuration

```bash
DOWNLOADS="/storage/emulated/0/Download"   # where to look for .tar files
HA_ROOT="/storage/emulated/0/HA"           # where to place the extracted data/
```

---

## Limitations

- Only processes the **most recent** `.tar` in `Download/` — move older files out of the way to restore from a specific backup
- Old `data__before_restore__*` folders are not automatically cleaned up
- Editing local files has no effect on your running HA instance — changes must be transferred back manually
