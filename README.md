# 🏠 ha-termux-tools

> Bash scripts to work with Home Assistant configuration files from Android using Termux.

This toolkit maintains a **local mirror of your Home Assistant configuration** on your Android device.
It allows you to quickly search, inspect, and edit configuration files directly from Termux using fast command-line tools.

---

## Why this exists

Searching a large Home Assistant configuration directly on a phone is inconvenient.

This toolkit solves that by:

1. Extracting your HA configuration from a backup to a **local mirror**
2. Allowing fast contextual searches using **ripgrep**
3. Making configuration files easy to browse and edit on your phone

No connection to the running HA instance is required.

---

## Workflow

```
Home Assistant
      │
      │  export backup
      ▼
backup.tar  (Download/)
      │
      │  ha_restore.sh
      ▼
/storage/emulated/0/HA/data/
      │
      │  ha_find_contexte.sh
      ▼
search results
```

---

## 📦 Scripts

### `ha_find_contexte.sh` — Search with context

Search any keyword across all HA configuration files (`yaml`, `json`, `jinja2`, etc.) and display results with surrounding lines for full context.

**How it works:**
- Opens an Android dialog to enter the search term
- Runs a recursive search with [ripgrep](https://github.com/BurntSushi/ripgrep)
- Generates a formatted `.txt` report
- Displays matching lines (`>>>`) with ±5 lines of context
- Opens the result file automatically

**Android dialog interface:**

![74955](https://github.com/user-attachments/assets/eaa2d1e8-a63d-4936-b09d-2fde6080084e)

**Example output:**

```
============================================================
Recherche Home Assistant — AVEC CONTEXTE (Termux)
------------------------------------------------------------
Date    : 2025-01-15 14:32:01
Racine  : /storage/emulated/0/HA/data
Requête : notify
Contexte: ±5 lignes
============================================================

------------------------------------------------------------
Fichier : /storage/emulated/0/HA/data/automations.yaml
------------------------------------------------------------
        4 |  trigger:
        5 |    platform: state
        6 |    entity_id: binary_sensor.door
>>>      7 |  action: notify.mobile_app
        8 |    message: "Porte ouverte"
```

---

### `ha_restore.sh` — Extract a backup locally

Extracts a Home Assistant backup `.tar` from your `Download/` folder and places the configuration files at `/storage/emulated/0/HA/data/` on your device.

This creates a **local mirror of your HA configuration** on the phone.

> ⚠️ This script does **not** interact with a running Home Assistant instance.
> It only extracts configuration files from a backup archive.

**How it works:**
- Detects the most recent `.tar` backup in `/storage/emulated/0/Download/`
- Validates the file is a genuine HA backup
- Extracts both archive levels (tar-in-tar)
- Requests **explicit confirmation** before replacing local files
- Renames the previous `data/` folder instead of deleting it
- Cleans up temporary files

**Safety features:**
- ✅ Fully cancellable via Android dialog
- ✅ Previous local `data/` folder preserved with timestamp
- ✅ Validation that extracted data exists and is non-empty

---

## ⚙️ Requirements

| Tool | Install |
|------|---------|
| [Termux](https://f-droid.org/packages/com.termux/) | F-Droid (recommended) |
| [Termux:API](https://f-droid.org/packages/com.termux.api/) | F-Droid |
| `termux-api` | `pkg install termux-api` |
| `ripgrep` | `pkg install ripgrep` |
| `jq` | `pkg install jq` |

> ⚠️ Install Termux from **F-Droid**, not the Play Store (the Play Store version is outdated).

---

## 🚀 Installation

> ⚠️ `ha_restore.sh` replaces the folder `HA/data` on your device.
> A timestamped backup of the previous folder is kept, but run this script only if you understand its purpose.

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/ha-termux-tools.git
cd ha-termux-tools

# Make scripts executable
chmod +x *.sh

# Optional: add to PATH
mkdir -p ~/bin
cp *.sh ~/bin/
```

---

## 📁 Expected folder structure

```
/storage/emulated/0/
├── Download/
│   └── *.tar              ← HA backups exported from the HA UI
└── HA/
    ├── data/              ← local mirror of HA configuration
    └── results/           ← search output files
```

---

## 🔧 Configuration

Paths are defined at the top of each script and can be adjusted to match your setup:

```bash
# ha_find_contexte.sh
ROOT_DIR="/storage/emulated/0/HA/data"
OUT_DIR="/storage/emulated/0/HA/results"
CONTEXT_LINES=5

# ha_restore.sh
DOWNLOADS="/storage/emulated/0/Download"
HA_ROOT="/storage/emulated/0/HA"
```

---

## 📖 Documentation

Additional documentation is available in the [`docs/`](docs/) folder:

- [Installation guide](docs/INSTALL.md)
- [ha_find_contexte — full reference](docs/ha_find_contexte.md)
- [ha_restore — full reference](docs/ha_restore.md)

---

## 📄 License

MIT — free to use, modify, and redistribute.
