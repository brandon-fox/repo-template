#!/bin/bash
################################################################################
# Principles audit
#
# Sweeps every non-archived, non-fork repository of the given owners and
# reports, per repository, whether each of the six principles in
# https://github.com/First-ADE/.github/blob/main/PRINCIPLES.md holds in the
# form a script can check:
#
#   open         LICENSE is MIT, holder "Brandon Fox"
#   independent  README.md has a "## Independence" section
#   honest       README.md line 1 is "# <name>"; a "> **Status:**" line in lines 2-11
#   attributed   .mailmap exists; recent commit authors (after .mailmap) are mine or bots
#   separated    no employer term appears in the tree (allow-listed repos may
#                name an employer as career history, never as code provenance)
#   secrets      gitleaks finds nothing (skipped when gitleaks is not installed)
#
# Output is a Markdown table on stdout; exit 1 if any cell is FAIL.
#
# Usage: scripts/principles_audit.sh [owner ...]
#   default owners: brandon-fox First-ADE vindicta-platform
# Environment:
#   PRINCIPLES_WORKDIR       where to clone (default: a temp dir, removed on exit)
#   PRINCIPLES_DENYLIST      comma-separated regexes that must not appear in code
#   PRINCIPLES_ALLOW_MENTION comma-separated repos allowed to mention an employe
#   PRINCIPLES_AUTHOR_RE     regex every recent commit author email must match
#   PRINCIPLES_DEPTH         commits to inspect per repo (default 50)
################################################################################

set -uo pipefail

OWNERS=("$@")
[ ${#OWNERS[@]} -eq 0 ] && OWNERS=(brandon-fox First-ADE vindicta-platform)

DEPTH="${PRINCIPLES_DEPTH:-50}"
DENYLIST="${PRINCIPLES_DENYLIST:-capital ?one,capitalone\.com}"
ALLOW_MENTION="${PRINCIPLES_ALLOW_MENTION:-brandon-fox/brandon-fox,brandon-fox/brandon-fox.github.io}"
AUTHOR_RE="${PRINCIPLES_AUTHOR_RE:-brandon-fox@users\.noreply\.github\.com$|\[bot\]@users\.noreply\.github\.com$}"

CLEANUP=0
if [ -z "${PRINCIPLES_WORKDIR:-}" ]; then
  PRINCIPLES_WORKDIR="$(mktemp -d)"
  CLEANUP=1
fi
trap '[ "$CLEANUP" -eq 1 ] && rm -rf "$PRINCIPLES_WORKDIR"' EXIT

command -v gh >/dev/null || { echo "gh is required" >&2; exit 2; }
command -v git >/dev/null || { echo "git is required" >&2; exit 2; }
HAVE_GITLEAKS=0
command -v gitleaks >/dev/null && HAVE_GITLEAKS=1

FAILS=0
ROWS=()

check_repo() {
  local repo="$1" dir="$2"
  local open independent honest attributed separated secrets

  # open
  if [ -f "$dir/LICENSE" ] && grep -q '^MIT License' "$dir/LICENSE" \
     && grep -qE '^Copyright \(c\) [0-9]{4} Brandon Fox\s*$' "$dir/LICENSE"; then
    open=PASS
  else
    open=FAIL
  fi

  # independent
  if [ -f "$dir/README.md" ] && grep -qE '^## Independence' "$dir/README.md"; then
    independent=PASS
  else
    independent=FAIL
  fi

  # honest
  if [ -f "$dir/README.md" ] \
     && head -n 1 "$dir/README.md" | tr -d '\r' | grep -qE '^# ' \
     && sed -n '2,11p' "$dir/README.md" | tr -d '\r' | grep -qE '^> \*\*Status:\*\*'; then
    honest=PASS
  else
    honest=FAIL
  fi

  # attributed
  local bad_authors
  # %aE applies .mailmap, so an old commit email that .mailmap claims is still mine.
  bad_authors=$(git -C "$dir" log -n "$DEPTH" --format='%aE' | sort -u | grep -vE "$AUTHOR_RE" || true)
  if [ -f "$dir/.mailmap" ] && [ -z "$bad_authors" ]; then
    attributed=PASS
  elif [ -z "$bad_authors" ]; then
    attributed="FAIL (no .mailmap)"
  else
    attributed="FAIL ($(echo "$bad_authors" | tr '\n' ' '))"
  fi

  # separated
  local hits
  hits=$(grep -rIiEl "$(echo "$DENYLIST" | tr ',' '|')" "$dir" \
          --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=.venv 2>/dev/null | wc -l | tr -d ' ')
  if [ "$hits" -eq 0 ]; then
    separated=PASS
  elif echo ",$ALLOW_MENTION," | grep -q ",$repo,"; then
    separated="PASS (allow-listed, $hits file(s) mention)"
  else
    separated="FAIL ($hits file(s))"
  fi

  # secrets
  if [ "$HAVE_GITLEAKS" -eq 1 ]; then
    if gitleaks detect --no-banner --no-git -s "$dir" --exit-code 1 >/dev/null 2>&1; then
      secrets=PASS
    else
      secrets=FAIL
    fi
  else
    secrets=skipped
  fi

  local row="| $repo | $open | $independent | $honest | $attributed | $separated | $secrets |"
  ROWS+=("$row")
  case "$row" in *FAIL*) FAILS=$((FAILS + 1));; esac
}

for owner in "${OWNERS[@]}"; do
  while IFS= read -r repo; do
    [ -z "$repo" ] && continue
    name="${repo//\//--}"
    dir="$PRINCIPLES_WORKDIR/$name"
    if [ -d "$dir/.git" ]; then
      git -C "$dir" fetch -q --depth "$DEPTH" origin >/dev/null 2>&1 || true
      git -C "$dir" reset -q --hard FETCH_HEAD >/dev/null 2>&1 || true
    else
      git clone -q --depth "$DEPTH" "https://github.com/$repo" "$dir" >/dev/null 2>&1 \
        || { ROWS+=("| $repo | clone failed | | | | | |"); FAILS=$((FAILS + 1)); continue; }
    fi
    if ! git -C "$dir" rev-parse -q --verify HEAD >/dev/null 2>&1; then
      ROWS+=("| $repo | empty repository | | | | | |"); FAILS=$((FAILS + 1)); continue
    fi
    check_repo "$repo" "$dir"
  done < <(gh repo list "$owner" --limit 200 --no-archived --source \
            --json nameWithOwner --jq '.[].nameWithOwner' | sort)
done

echo "# Principles audit — $(date -u +%Y-%m-%dT%H:%MZ)"
echo
echo "Owners: ${OWNERS[*]}. Depth: $DEPTH commits. gitleaks: $([ "$HAVE_GITLEAKS" -eq 1 ] && echo on || echo off)."
echo
echo "| repository | open | independent | honest | attributed | separated | secrets |"
echo "|---|---|---|---|---|---|---|"
printf '%s\n' "${ROWS[@]}"
echo
if [ "$FAILS" -gt 0 ]; then
  echo "**$FAILS repository(ies) with at least one FAIL.** Fix, then re-run; a principle is audited, then fixed, never only annotated."
  exit 1
else
  echo "**All repositories pass.**"
fi
