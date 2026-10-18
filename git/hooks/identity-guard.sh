#!/bin/sh
# Refuse commits whose author or committer email isn't a GitHub noreply
# address, so personal/work emails never land in commit metadata.
# Runs in every repo via the global config hook in ~/.sword/git/gitconfig
# (Git >= 2.54). Skip once: git -c hook.identity-guard.enabled=false commit
status=0
for who in AUTHOR COMMITTER; do
  email=$(git var "GIT_${who}_IDENT" | sed -E 's/.*<([^>]*)>.*/\1/')
  case "$email" in
    *@users.noreply.github.com) ;;
    *) echo "identity-guard: $who email <$email> is not a GitHub noreply address" >&2
       status=1 ;;
  esac
done
exit $status
