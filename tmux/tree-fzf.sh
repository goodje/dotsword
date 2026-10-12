#!/bin/bash
# Fuzzy-pick a tmux session/window/pane from a tree view (like `prefix s`),
# then switch to it. Meant to run inside `tmux display-popup -E`.
# Typing prunes the tree to matching rows plus their parents (parents dimmed).
# Needs fzf >= 0.66 (--raw).

# --list <rows-file> <query>: print the pruned, rendered tree for fzf's reload
if [ "$1" = --list ]; then
  rows=$2 q=$3
  if [ -n "$q" ]; then
    matched=$(fzf --filter "$q" --ansi --delimiter '\t' --nth 3 < "$rows" | cut -f1)
  else
    matched=$(cut -f1 < "$rows")
  fi
  [ -z "$matched" ] && exit
  printf '%s\n' "$matched" | awk -F'\t' '
    # keep matched rows and their ancestors ("s:" for sessions, "s:w" for windows)
    NR == FNR { keep[$1] = 1; split($1, a, "."); keep[a[1]] = 1
                keep[substr($1, 1, index($1, ":"))] = 1; next }
    keep[$1] { n++; t[n] = $1; lv[n] = $2; d[n] = $3 }
    END {
      # render tree glyphs, computing last-sibling status on the pruned list
      for (r = 1; r <= n; r++) {
        last = 1
        for (k = r + 1; k <= n && lv[k] >= lv[r]; k++) if (lv[k] == lv[r]) { last = 0; break }
        if (lv[r] == 0) g = ""
        else if (lv[r] == 1) { g = (last ? "└─ " : "├─ "); wlast = last }
        else g = (wlast ? "   " : "│  ") (last ? "└─ " : "├─ ")
        printf "%s\t%s%s\n", t[r], g, d[r]
      }
    }' - "$rows"
  exit
fi

rows=$(mktemp)
trap 'rm -f "$rows"' EXIT

# rows: target \t level \t display
tmux list-panes -a -F \
  $'#{session_name}\t#{window_index}\t#{window_name}\t#{window_panes}\t#{pane_index}\t#{pane_current_command}\t#{pane_current_path}\t#{session_windows}' |
  awk -F'\t' -v home="$HOME" '{
    s = $1; w = $2; p = $5; path = $7; sub("^" home, "~", path)
    if (s != prev_s) { printf "%s:\t0\t\033[1;32m%s\033[0m: %d windows\n", s, s, $8; prev_s = s; prev_w = "" }
    if (w != prev_w) {
      if ($4 == 1) printf "%s:%s.%s\t1\t%s: \033[36m%s\033[0m  %s  \033[2m%s\033[0m\n", s, w, p, w, $3, $6, path
      else         printf "%s:%s\t1\t%s: \033[36m%s\033[0m  (%d panes)\n", s, w, w, $3, $4
      prev_w = w
    }
    if ($4 > 1) printf "%s:%s.%s\t2\t%s.%s  %s  \033[2m%s\033[0m\n", s, w, p, w, p, $6, path
  }' > "$rows"

self=$0
target=$("$self" --list "$rows" "" |
  fzf --ansi --raw --no-sort --reverse --delimiter '\t' --with-nth 2.. \
      --bind "change:reload-sync:\"$self\" --list \"$rows\" {q}" \
      --preview 'tmux capture-pane -ep -t {1}' --preview-window right,50% |
  cut -f1)

[ -n "$target" ] && tmux switch-client -t "$target"
