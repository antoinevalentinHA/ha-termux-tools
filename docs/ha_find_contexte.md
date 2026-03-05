# ha_find_contexte

Search Home Assistant configuration files with contextual output.

---

## Purpose

Large Home Assistant configurations can contain hundreds of YAML files spread across many subdirectories.

This script allows searching them quickly from a phone, with enough surrounding context to understand each match without opening the file.

---

## Features

- Android dialog for search input
- Recursive, case-insensitive search using [ripgrep](https://github.com/BurntSushi/ripgrep)
- ±5 lines of context around each match
- Structured, readable output file
- Result file opened automatically on completion

---

## Supported file types

| Extension | Typical use in HA |
|-----------|------------------|
| `.yaml` / `.yml` | Automations, scripts, configuration |
| `.json` | Lovelace dashboards, storage |
| `.j2` / `.jinja` / `.jinja2` | Templates |
| `.txt` | Custom notes, helpers |
| `.md` | Documentation inside config |

The following directories are excluded:

- `.storage/` — internal HA state
- `.git/` — version control metadata
- `__pycache__/`, `deps/`, `node_modules/` — dependencies

---

## Usage

```bash
scripts/ha_find_contexte.sh
```

Enter the search term when the dialog appears. The result file opens automatically when the search completes.

Results are saved to:

```
/storage/emulated/0/HA/results/recherche_contexte_<query>_<timestamp>.txt
```

Cancel/empty input exits without changes.

---

## Output format

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

- Lines prefixed with `>>>` are direct matches
- All other lines are context

---

## Configuration

Edit these variables at the top of the script:

```bash
ROOT_DIR="/storage/emulated/0/HA/data"   # directory to search
OUT_DIR="/storage/emulated/0/HA/results" # where to save result files
CONTEXT_LINES=5                          # lines of context around each match
```

---

## Search tips

- Search is **case-insensitive** by default
- Works with partial strings: `trigger`, `template`, `notify`
- Works with entity IDs: `light.salon`, `binary_sensor.door`
- Special characters in the query are sanitized in the output filename

---

## Limitations

- Binary files are skipped automatically
- The `.storage/` directory is excluded (internal HA state, not user config)
- Result files accumulate in `OUT_DIR` — clean them up manually as needed
