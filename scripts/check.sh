#!/bin/sh
# Usage: scripts/check.sh industry research ...
# Reads dist/<variant>.log after a build.
max=${MAX_PAGES:-1}
status=0
for v in "$@"; do
  log="dist/$v.log"
  pages=$(grep -o 'Output written on .*(\([0-9]*\) page' "$log" | grep -o '[0-9]* page' | cut -d' ' -f1)
  overfull=$(grep -c '^Overfull \\hbox' "$log")
  missing=$(grep -c '^Missing character' "$log")
  printf '%-16s %s page(s)' "$v" "${pages:-?}"
  [ "$overfull" -gt 0 ] && printf ', %s overfull line(s)' "$overfull"
  [ "$missing" -gt 0 ] && printf ', %s missing character(s)' "$missing"
  printf '\n'
  if [ -z "$pages" ] || [ "$pages" -gt "$max" ]; then
    echo "  -> longer than $max page(s); trim content or tighten styles/theme.tex"
    status=1
  fi
  if [ "$overfull" -gt 0 ]; then
    grep -A1 '^Overfull \\hbox' "$log" | sed 's/^/  /'
  fi
  if [ "$missing" -gt 0 ]; then
    grep '^Missing character' "$log" | sort -u | sed 's/^/  /'
  fi
done
exit $status
