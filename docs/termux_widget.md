# 🛠️ Setup Guide — Termux Script with Android Home Screen Shortcut

This guide explains how to:

- install the scripts from the repository
- run them from Termux
- create a home screen shortcut using Termux:Widget
- launch the tool in one tap

No network access to Home Assistant is required.

---

## 🎯 Goal

Run HA configuration inspection tools from an Android phone using:

- **Termux**
- a native Android dialog
- a home screen widget

The scripts work on a local mirror of the HA configuration and never interact with the running Home Assistant instance.

---

## 📦 Requirements

Install the following Android apps:

- [Termux](https://f-droid.org/packages/com.termux/) *(from F-Droid)*
- [Termux:API](https://f-droid.org/packages/com.termux.api/)
- [Termux:Widget](https://f-droid.org/packages/com.termux.widget/)

> ⚠️ F-Droid is recommended — the Play Store version of Termux is outdated.

---

## ⚙️ Step 1 — Prepare Termux

Open Termux and run:

```bash
pkg update
pkg upgrade
pkg install git ripgrep jq termux-api
termux-setup-storage
```

Grant storage permission when prompted.

---

## 📁 Step 2 — Create the working directories

The scripts expect the following folders:

```bash
mkdir -p /storage/emulated/0/HA/data
mkdir -p /storage/emulated/0/HA/results
```

---

## 📥 Step 3 — Install the scripts

Clone the repository:

```bash
git clone https://github.com/antoinevalentinHA/ha-termux-tools.git
cd ha-termux-tools
chmod +x scripts/*.sh
```

To test a script directly:

```bash
scripts/ha_find_contexte.sh
```

---

## 🔗 Step 4 — Create a home screen shortcut

Termux:Widget reads scripts from the `~/.shortcuts` folder.

Create the folder if needed:

```bash
mkdir -p ~/.shortcuts
```

Create a symbolic link to the script:

```bash
ln -s ~/ha-termux-tools/scripts/ha_find_contexte.sh ~/.shortcuts/ha_find_contexte
```

Verify:

```bash
ls -l ~/.shortcuts
```

> 💡 If the script does not appear in the widget, restart the Termux app.

---

## 📱 Step 5 — Add the widget

1. Long-press the Android home screen
2. Add the **Termux:Widget** widget
3. Select the shortcut script

The script can now be launched with a single tap.

---

## ✅ Result

You can now:

- launch the script from the home screen
- enter the search term via the Android dialog
- view contextual results immediately
