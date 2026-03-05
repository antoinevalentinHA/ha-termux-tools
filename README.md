# 🏠 ha-termux-tools

> Bash scripts to manage Home Assistant from Android via Termux.

Two lightweight utilities for Home Assistant users who administer their instance from an Android phone via [Termux](https://termux.dev).

---

## 📦 Scripts

### `ha_find_contexte.sh` — Search with context

Search any keyword across all HA configuration files (`yaml`, `json`, `jinja2`, etc.) and display results with surrounding lines for full context.

**How it works:**
- Opens an Android dialog to enter the search term
- Runs a recursive search with [ripgrep](https://github.com/BurntSushi/ripgrep)
- Generates a formatted `.txt` file with matches (`>>>`) and ±5 lines of context
- Opens the result file automatically

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

> ⚠️ This script does **not** interact with a running Home Assistant instance. It creates a local copy of your config on the phone — typically used as a prerequisite for `ha_find_contexte`.

**How it works:**
- Detects the most recent `.tar` backup in `/storage/emulated/0/Download/`
- Validates the file is a genuine HA backup (checks for `homeassistant` inside)
- Extracts both archive levels (tar-in-tar)
- Asks for **explicit confirmation** before touching any existing local data
- Renames the old `data/` to `data__before_restore__<timestamp>` instead of deleting it
- Cleans up temporary files

**Safety:**
- ✅ Cancellable at every step via dialog
- ✅ Previous local `data/` is kept, not deleted — easy to roll back
- ✅ Validates the extracted folder is non-empty before proceeding

---

## ⚙️ Requirements

| Tool | Install |
|------|---------|
| [Termux](https://f-droid.org/packages/com.termux/) | F-Droid (recommended) |
| [Termux:API](https://f-droid.org/packages/com.termux.api/) | F-Droid |
| `termux-api` | `pkg install termux-api` |
| `ripgrep` | `pkg install ripgrep` |
| `jq` | `pkg install jq` |

> ⚠️ Install Termux from **F-Droid**, not the Play Store (outdated version).

---

## 🚀 Installation

> ⚠️ `ha_restore.sh` replaces `HA/data` on your device. A timestamped backup of the previous folder is kept, but only run this script if you understand what it does.

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/ha-termux-tools.git
cd ha-termux-tools
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
    ├── data/              ← local copy of HA configuration (set by ha_restore)
    └── results/           ← search output files (written by ha_find_contexte)
```

---

## 🔧 Configuration

Paths are defined at the top of each script and can be changed to match your setup:

```bash
# ha_find_contexte.sh
ROOT_DIR="/storage/emulated/0/HA/data"
OUT_DIR="/storage/emulated/0/HA/results"
CONTEXT_LINES=5   # lines of context shown around each match

# ha_restore.sh
DOWNLOADS="/storage/emulated/0/Download"
HA_ROOT="/storage/emulated/0/HA"
```

---

## 📖 Documentation

- [Installation Guide](docs/INSTALL.md)
- [ha_find_contexte — full reference](docs/ha_find_contexte.md)
- [ha_restore — full reference](docs/ha_restore.md)

---

## 📄 License

MIT — free to use, modify, and redistribute.
