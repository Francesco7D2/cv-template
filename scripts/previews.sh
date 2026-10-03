#!/bin/sh
# Usage: scripts/previews.sh industry research ...
# Renders page one of dist/<variant>.pdf to docs/<variant>.png.
# Uses pdftoppm (poppler) if installed, otherwise sips on macOS.
mkdir -p docs
for v in "$@"; do
  if command -v pdftoppm >/dev/null 2>&1; then
    pdftoppm -png -r 110 -singlefile "dist/$v.pdf" "docs/$v"
  elif command -v sips >/dev/null 2>&1; then
    sips -s format png -Z 1300 "dist/$v.pdf" --out "docs/$v.png" >/dev/null
  else
    echo "Install poppler (pdftoppm) to render previews." >&2
    exit 1
  fi
  echo "docs/$v.png"
done
