# Installation Guide

This guide explains how to install the required tools to use **ha-termux-tools** on Android.

---

## 1. Install Termux

Install Termux from **F-Droid**, not from the Play Store — the Play Store version is no longer maintained.

→ [F-Droid: com.termux](https://f-droid.org/packages/com.termux/)

---

## 2. Install Termux:API

Required for Android dialog boxes used by both scripts.

→ [F-Droid: com.termux.api](https://f-droid.org/packages/com.termux.api/)

---

## 3. Install required packages

Open Termux and run:

```bash
pkg update
pkg install ripgrep jq termux-api
```

| Tool | Purpose |
|------|---------|
| `ripgrep` | Fast recursive file search |
| `jq` | JSON parsing for dialog output |
| `termux-api` | Android dialog support |

---

## 4. Grant storage permission

The scripts need access to `/storage/emulated/0/`. Run:

```bash
termux-setup-storage
```

Tap **Allow** when the permission dialog appears.

---

## 5. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/ha-termux-tools.git
cd ha-termux-tools
chmod +x scripts/*.sh
```

---

## 6. Optional — add scripts to PATH

```bash
mkdir -p ~/bin
cp scripts/*.sh ~/bin/
```

Then restart Termux

---

## Verify installation

Run this to confirm all dependencies are available:

```bash
for cmd in rg jq termux-dialog termux-open; do
  command -v "$cmd" && echo "OK: $cmd" || echo "MISSING: $cmd"
done
```

All four should return `OK` before using the scripts.
