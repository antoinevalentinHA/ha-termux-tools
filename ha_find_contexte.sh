#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# 🧠 ARSENAL — ha_find_contexte
# Recherche Home Assistant AVEC CONTEXTE (Android / Termux)
# ------------------------------------------------------------
# - Saisie via boîte de dialogue Android
# - Recherche récursive avec ripgrep
# - Rendu structuré type ARSENAL
# - Contexte lisible ±N lignes
# - Sortie TXT + ouverture automatique
# ============================================================

set -u

ROOT_DIR="/storage/emulated/0/HA/data"
OUT_DIR="/storage/emulated/0/HA/results"

CONTEXT_LINES=5

# ------------------------------------------------------------
# 0) Prérequis
# ------------------------------------------------------------
need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing dependency: $1"; exit 1; }; }
need rg
need jq
need termux-dialog
need termux-open

# ------------------------------------------------------------
# 1) Saisie utilisateur
# ------------------------------------------------------------
DIALOG_JSON=$(termux-dialog text \
  -t "Recherche Home Assistant (contexte)" \
  -i "Texte à rechercher" 2>/dev/null || true)

QUERY=$(echo "$DIALOG_JSON" | jq -r '.text // ""' 2>/dev/null || echo "")

[ -z "$QUERY" ] && exit 0

# ------------------------------------------------------------
# 2) Préparation
# ------------------------------------------------------------
mkdir -p "$OUT_DIR"
TIMESTAMP=$(date "+%Y%m%d_%H%M%S")

# SAFE_QUERY: garde lettres/chiffres/._- et remplace le reste
SAFE_QUERY=$(echo "$QUERY" | sed 's/[^a-zA-Z0-9._-]/_/g')
OUT_FILE="$OUT_DIR/recherche_contexte_${SAFE_QUERY}_${TIMESTAMP}.txt"

TMP_FILE=$(mktemp)

# ------------------------------------------------------------
# 3) Recherche brute (sans couleur, sans bruit)
# ------------------------------------------------------------
rg --ignore-case \
   --line-number \
   --context "$CONTEXT_LINES" \
   --color=never \
   --glob '*.yaml' \
   --glob '*.yml' \
   --glob '*.json' \
   --glob '*.txt' \
   --glob '*.j2' \
   --glob '*.jinja' \
   --glob '*.jinja2' \
   --glob '*.md' \
   --glob '!.storage/**' \
   --glob '!.git/**' \
   --glob '!__pycache__/**' \
   --glob '!deps/**' \
   --glob '!node_modules/**' \
   "$QUERY" "$ROOT_DIR" > "$TMP_FILE" 2>/dev/null || true

# ------------------------------------------------------------
# 4) En-tête ARSENAL
# ------------------------------------------------------------
{
  echo "============================================================"
  echo "Recherche Home Assistant — AVEC CONTEXTE (Termux)"
  echo "------------------------------------------------------------"
  echo "Date    : $(date '+%Y-%m-%d %H:%M:%S')"
  echo "Racine  : $ROOT_DIR"
  echo "Requête : $QUERY"
  echo "Contexte: ±$CONTEXT_LINES lignes"
  echo "============================================================"
  echo
} > "$OUT_FILE"

# ------------------------------------------------------------
# 5) Mise en forme ARSENAL
# ------------------------------------------------------------
if [ ! -s "$TMP_FILE" ]; then
  echo "Aucune occurrence trouvée." >> "$OUT_FILE"
  echo >> "$OUT_FILE"
  echo "Astuce: vérifier la racine, ou réduire la requête." >> "$OUT_FILE"
else
  awk '
    BEGIN { last_file="" }

    /^--$/ { next }

    {
      # Match: file:line:content
      if ($0 ~ /^[^:]+:[0-9]+:/) {
        split($0, a, ":")
        file=a[1]; line=a[2]
        content=$0
        sub(/^[^:]+:[0-9]+:/, "", content)
        type="match"
      }
      # Context: file-line-content
      else if ($0 ~ /^[^:]+-[0-9]+-/) {
        split($0, a, "-")
        file=a[1]; line=a[2]
        content=$0
        sub(/^[^:]+-[0-9]+-/, "", content)
        type="context"
      } else { next }

      if (file != last_file) {
        if (last_file != "") print "\n" >> out
        print "------------------------------------------------------------" >> out
        print "Fichier : " file >> out
        print "------------------------------------------------------------" >> out
        last_file = file
      }

      if (type == "match") {
        printf(">>> %4d |%s\n", line, content) >> out
      } else {
        printf("     %4d |%s\n", line, content) >> out
      }
    }
  ' out="$OUT_FILE" "$TMP_FILE"
fi

rm -f "$TMP_FILE"

# ------------------------------------------------------------
# 6) Ouverture automatique
# ------------------------------------------------------------
termux-open "$OUT_FILE"
