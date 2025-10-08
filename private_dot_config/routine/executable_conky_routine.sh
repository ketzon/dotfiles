#!/usr/bin/env bash
set -euo pipefail

CFG="$HOME/.config/routine/routine.conf"
now=$(date +%s)
dow=$(date +%u) 
today=()

while IFS='|' read -r t label days || [[ -n "${t:-}" ]]; do
  [[ -z "${t// }" || "${t:0:1}" == "#" ]] && continue
  if [[ "$days" == "*" || "$days" == *"$dow"* ]]; then
    sec=$(date -d "$(date +%F) $t" +%s 2>/dev/null || date -j -f "%F %H:%M" "$(date +%F) $t" +%s)
    today+=("$sec|$t|$label")
  fi
done < "$CFG"

IFS=$'\n' today=($(printf "%s\n" "${today[@]}" | sort -n))
unset IFS

current_idx=-1
for i in "${!today[@]}"; do
  ts=${today[$i]%%|*}
  if (( now >= ts )); then current_idx=$i; fi
done

echo "\${voffset 6}\${font Sans:bold:size=10}Routine du jour\${font}"
echo "\${voffset 4}\${hr 2}"
for i in "${!today[@]}"; do
  rest="${today[$i]#*|}"; time="${rest%%|*}"; label="${rest#*|}"
  if (( i == current_idx )); then
    echo "\${color #ffffff}\${font Sans:bold:size=10}▶ $time  $label\${font}\${color}"
  else
    echo "\${color #aab}\${font Sans:size=9}$time  $label\${font}\${color}"
  fi
done

next_msg=""
if (( current_idx + 1 < ${#today[@]} )); then
  nrest="${today[$((current_idx+1))]#*|}"; ntime="${nrest%%|*}"; nlabel="${nrest#*|}"
  next_ts=${today[$((current_idx+1))]%%|*}
  mins=$(( (next_ts - now) / 60 ))
  (( mins < 0 )) && mins=0
  next_msg="Dans ~${mins} min → $nlabel"
fi
echo "\${voffset 4}\${hr 1}"
[[ -n "$next_msg" ]] && echo "\${color #8fd}\${font Sans:italic:size=8}$next_msg\${font}\${color}"
