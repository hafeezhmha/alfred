#!/usr/bin/env bash
# Tests for the ./life launcher. Run from anywhere: bash .github/tests/life.sh
# Each test runs in a fresh copy of the template, so the repo is never touched.
set -u

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0; FAIL=0

days_ago() { date -d "$1 days ago" +%Y-%m-%d 2>/dev/null || date -v-"$1"d +%Y-%m-%d; }
TODAY="$(date +%Y-%m-%d)"

fresh() { # new sandbox with the template; "setup" also applies the Sam example
  T="$(mktemp -d)"
  cp -R "$REPO/life" "$REPO/AGENTS.md" "$REPO/CLAUDE.md" "$REPO/context.md" \
    "$REPO/current.md" "$REPO/queue.md" "$REPO/.life" "$REPO/.claude" "$REPO/areas" "$T/"
  if [ "${1:-}" = setup ]; then rm "$T/.life/SETUP_NEEDED"; cp "$REPO"/examples/sam/*.md "$T/"; fi
  cd "$T" || exit 1
}
ok()   { PASS=$((PASS + 1)); }
bad()  { FAIL=$((FAIL + 1)); echo "FAIL: $1"; [ -n "${2:-}" ] && printf '%s\n' "$2" | sed 's/^/    /'; }
has()  { case "$2" in *"$3"*) ok ;; *) bad "$1: expected '$3'" "$2" ;; esac; }
lacks(){ case "$2" in *"$3"*) bad "$1: did not expect '$3'" "$2" ;; *) ok ;; esac; }
crlf() { awk '{printf "%s\r\n", $0}' "$1" > "$1.tmp" && mv "$1.tmp" "$1"; }

# --- status / start before setup
fresh
out="$(./life status 2>&1)"; has "unset status" "$out" "Not set up yet"
out="$(./life start 2>&1)"; lacks "unset start skips context" "$out" "=== context.md"
out="$(./life check 2>&1)"; has "unset check" "$out" "all good"

# --- status after setup
fresh setup
out="$(./life status 2>&1)"
has "status stopped-at" "$out" "Stopped at: IAM video 5"
has "status now" "$out" "IAM video 5 from 12:40"
has "status inbox" "$out" "Inbox: 1 unsorted"
has "status review none" "$out" "Weekly review: none yet"

echo garbage > .life/last-weekly-review
out="$(./life status 2>&1)"; rc=$?
[ $rc = 0 ] && ok || bad "bad stamp exit $rc" "$out"
lacks "bad stamp no error" "$out" "unbound"
echo $(( $(date +%s) - 8 * 86400 )) > .life/last-weekly-review
has "review due" "$(./life status)" "Weekly review due (last one 8 days ago)"
./life reviewed >/dev/null; lacks "review fresh" "$(./life status)" "Weekly review"

printf '# Current\n' > current.md
has "empty log fallback" "$(./life status)" "(no dated entry in current.md yet)"

# --- waiting-on ages
fresh setup
awk -v a="- Ana: form, since $TODAY" -v b="- Landlord, since $(days_ago 1)" \
    -v c="- Refund, since $(days_ago 15)" -v d="- Bank, no date" \
  '{print} /^## Waiting on/{print ""; print a; print b; print c; print d}' queue.md > q && mv q queue.md
out="$(./life status)"
has "age today" "$out" "since $TODAY (today)"
has "age 1" "$out" "since $(days_ago 1) (1 day)"
has "age 15" "$out" "since $(days_ago 15) (15 days)"
has "age none" "$out" "- Bank, no date"
lacks "age none has no count" "$out" "no date ("

# --- add
fresh setup
./life add 'pay \n bill & "rent" 50%' >/dev/null
./life add "$(printf 'two\nlines')" >/dev/null
q="$(cat queue.md)"
has "add keeps backslash" "$q" '- [ ] pay \n bill & "rent" 50% ('
has "add joins lines" "$q" "- [ ] two lines ($TODAY)"
has "add counted" "$(./life status)" "Inbox: 3 unsorted"

printf '# Queue\n\n## Now\n\n## Inbox\n' > queue.md
./life add x >/dev/null; ./life add y >/dev/null
[ "$(tail -2 queue.md)" = "- [ ] x ($TODAY)
- [ ] y ($TODAY)" ] && ok || bad "add to last section" "$(cat queue.md)"

printf '# Queue\n\n## Now\n' > queue.md
out="$(./life add z 2>&1)"; rc=$?
[ $rc != 0 ] && ok || bad "add without Inbox should fail"
has "add without Inbox message" "$out" "No '## Inbox'"

# --- Windows line endings
fresh setup
crlf queue.md; crlf current.md
out="$(./life status)"
has "crlf stopped-at" "$out" "Stopped at: IAM video 5"
has "crlf now" "$out" "IAM video 5 from 12:40"
has "crlf inbox" "$out" "Inbox: 1 unsorted"
./life add crlf-item >/dev/null && has "crlf add" "$(cat queue.md)" "crlf-item" || bad "crlf add failed"

# --- archive
fresh setup
cat > current.md <<EOF
# Current

\`\`\`
## YYYY-MM-DD — <topic>
\`\`\`

---

## $(days_ago 1) — recent

Stopped at: A.

## $(days_ago 20) — within four weeks

Stopped at: B.

## Undated section

stays

## $(days_ago 40) — old

Stopped at: C.
EOF
old_year="$(days_ago 40 | cut -c1-4)"
out="$(./life archive)"
has "archive count" "$out" "Moved 1 old entries"
c="$(cat current.md)"
has "archive keeps recent" "$c" "Stopped at: A."
has "archive keeps 20d" "$c" "Stopped at: B."
has "archive keeps undated" "$c" "## Undated section"
has "archive keeps fence" "$c" "## YYYY-MM-DD"
lacks "archive moved old" "$c" "Stopped at: C."
has "archive file" "$(cat "archive/current-$old_year.md")" "Stopped at: C."
has "archive idempotent" "$(./life archive)" "Nothing to archive"

printf '\n## %s — older\n\nStopped at: D.\n' "$(days_ago 50)" >> current.md
./life archive >/dev/null
first="$(grep -m1 '^## ' "archive/current-$old_year.md")"
[ "$(days_ago 50 | cut -c1-4)" != "$old_year" ] || has "archive newest first" "$first" "$(days_ago 50)"

printf '# Current\n\n## 2020-01-01 — ancient\n\nx\n' > current.md
./life archive >/dev/null
has "archive keeps only entry" "$(cat current.md)" "## 2020-01-01"

# --- start
fresh setup
out="$(./life start)"
has "start has status" "$out" "Stopped at: IAM video 5"
has "start has context" "$out" "=== context.md ==="
lacks "start no adhd when off" "$out" "ADHD mode"
touch .claude/.adhd-always
out="$(./life start)"
has "start adhd header" "$out" "ADHD mode is on"
has "start adhd rules" "$out" "First line is the next action"

# --- nudge (LIFE_NUDGE_DRY prints instead of notifying)
fresh setup
out="$(LIFE_NUDGE_DRY=1 ./life nudge)"
has "nudge names first Now item" "$out" "One thing today: IAM video 5 from 12:40"
lacks "nudge no checkbox" "$out" "[ ]"
./life start >/dev/null
out="$(LIFE_NUDGE_DRY=1 ./life nudge)"
[ -z "$out" ] && ok || bad "nudge skips after a session today" "$out"
has "nudge test forces" "$(LIFE_NUDGE_DRY=1 ./life nudge test)" "One thing today"
echo "09:30 private" > .life/nudge
out="$(LIFE_NUDGE_DRY=1 ./life nudge test)"
lacks "nudge private hides item" "$out" "IAM"
has "nudge private text" "$out" "Your one small step"

fresh
out="$(LIFE_NUDGE_DRY=1 ./life nudge test)"
[ -z "$out" ] && ok || bad "nudge silent before setup" "$out"

# on/off against a sandbox HOME, with launchctl/systemctl stubs that log calls
fresh setup
mkdir -p "$T/stub" "$T/home"
for c in launchctl systemctl; do printf '#!/bin/sh\necho "%s $*" >> "%s/calls"\n' "$c" "$T" > "$T/stub/$c"; chmod +x "$T/stub/$c"; done
out="$(HOME="$T/home" PATH="$T/stub:$PATH" ./life nudge on 7:5 2>&1)"; rc=$?
[ $rc != 0 ] && ok || bad "nudge rejects bad time" "$out"
out="$(HOME="$T/home" PATH="$T/stub:$PATH" ./life nudge on 09:05 2>&1)"
has "nudge on confirms" "$out" "every day at 09:05"
if [ "$(uname)" = Darwin ]; then
  p="$T/home/Library/LaunchAgents/com.life-os.nudge.plist"
  has "launchd hour" "$(cat "$p")" "<key>Hour</key><integer>9</integer>"
  has "launchd minute" "$(cat "$p")" "<key>Minute</key><integer>5</integer>"
  has "launchd path" "$(cat "$p")" "<string>$T/life</string>"
  has "launchctl load" "$(cat "$T/calls")" "launchctl load"
else
  has "systemd time" "$(cat "$T/home/.config/systemd/user/life-os-nudge.timer")" "OnCalendar=*-*-* 09:05:00"
  has "systemd path" "$(cat "$T/home/.config/systemd/user/life-os-nudge.service")" "ExecStart=/bin/bash \"$T/life\" nudge"
  has "systemctl enable" "$(cat "$T/calls")" "--user enable --now life-os-nudge.timer"
fi
HOME="$T/home" PATH="$T/stub:$PATH" ./life nudge off >/dev/null
left="$(find "$T/home" -type f)"
[ -z "$left" ] && ok || bad "nudge off removes schedule" "$left"
[ ! -f .life/nudge ] && ok || bad "nudge off removes config"

# --- Claude Code hook runs the same command
fresh
hook="$(awk -F'"command": "' 'NF > 1 {sub(/",$/, "", $2); print $2}' .claude/settings.json | sed 's/\\"/"/g')"
out="$(CLAUDE_PROJECT_DIR="$T" sh -c "$hook")"
has "hook runs life start" "$out" "Not set up yet"

echo "life tests: $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ]
