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

# list width: popup width minus the 50% preview, gutter and borders
width=$(( $(tput cols) / 2 - 4 ))

# rows: target \t level \t display
# Long paths are shortened in the middle; the full path is appended past the
# visible width (cut off by --no-hscroll) so it stays searchable.
tmux list-panes -a -F \
  $'#{session_name}\t#{window_index}\t#{window_name}\t#{window_panes}\t#{pane_index}\t#{pane_current_command}\t#{pane_current_path}\t#{session_windows}' |
  awk -F'\t' -v home="$HOME" -v width="$width" '
    # used = visible chars before the path, incl. tree glyphs (3 per level)
    function fit(path, used,   max, head, pad) {
      max = width - used
      if (length(path) <= max || max < 12) return "\033[2m" path "\033[0m"
      head = int((max - 2) / 3)
      pad = sprintf("%30s", "")
      return "\033[2m" substr(path, 1, head) ".." substr(path, length(path) - (max - 2 - head) + 1) "\033[0m" pad path
    }
    {
      s = $1; w = $2; p = $5; path = $7; sub("^" home, "~", path)
      if (s != prev_s) { printf "%s:\t0\t\033[1;32m%s\033[0m: %d windows\n", s, s, $8; prev_s = s; prev_w = "" }
      if (w != prev_w) {
        if ($4 == 1) printf "%s:%s.%s\t1\t%s: \033[36m%s\033[0m  %s  %s\n", s, w, p, w, $3, $6,
                       fit(path, 3 + length(w ": " $3 "  " $6 "  "))
        else         printf "%s:%s\t1\t%s: \033[36m%s\033[0m  (%d panes)\n", s, w, w, $3, $4
        prev_w = w
      }
      if ($4 > 1) printf "%s:%s.%s\t2\t%s.%s  %s  %s\n", s, w, p, w, p, $6,
                    fit(path, 6 + length(w "." p "  " $6 "  "))
    }' > "$rows"

self=$0
target=$("$self" --list "$rows" "" |
  fzf --ansi --raw --no-sort --reverse --no-hscroll --ellipsis '' --delimiter '\t' --with-nth 2.. \
      --bind "change:reload-sync:\"$self\" --list \"$rows\" {q}" \
      --preview 'tmux capture-pane -ep -t {1}' --preview-window right,50% |
  cut -f1)

[ -n "$target" ] && tmux switch-client -t "$target"
