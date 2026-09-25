#!/usr/bin/env bash
# Tests for the ./life launcher. Run from anywhere: bash .github/tests/life.sh
# Each test runs in a fresh copy of the template, so the repo is never touched.
set -u

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
PASS=0; FAIL=0

days_ago() { date -d "$1 days ago" +%Y-%m-%d 2>/dev/null || date -v-"$1"d +%Y-%m-%d; }
TODAY="$(date +%Y-%m-%d)"

fresh() { # new sandbox with the template; "setup" also applies the Kavya example
  T="$(mktemp -d)"
  cp -R "$REPO/life" "$REPO/AGENTS.md" "$REPO/CLAUDE.md" "$REPO/context.md" \
    "$REPO/current.md" "$REPO/queue.md" "$REPO/.life" "$REPO/.claude" "$REPO/areas" "$T/"
  if [ "${1:-}" = setup ]; then rm "$T/.life/SETUP_NEEDED"; cp "$REPO"/examples/kavya/*.md "$T/"; fi
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
out="$(./life start 2>&1)"; lacks "unset start skips context" "$out" "context:"
has "unset ritual is setup" "$(./life ritual)" "ritual: setup"
out="$(./life check 2>&1)"; has "unset check" "$out" "all good"

# --- status after setup
fresh setup
out="$(./life status 2>&1)"
has "status stopped-at" "$out" '  at: `retry_test.go`, test case 3'
has "status stopped joins lines" "$out" 'idempotency key). The fixture needs'
has "status now" "$out" "now[2/3]:
  n1 Retry tests from case 3"
has "status counts" "$out" "counts: next 3 · inbox 2"
has "status review none" "$out" "review: none yet"
has "status ritual" "$out" "ritual: "
has "status next hints" "$out" "next:
  ./life ritual"

echo garbage > .life/last-weekly-review
out="$(./life status 2>&1)"; rc=$?
[ $rc = 0 ] && ok || bad "bad stamp exit $rc" "$out"
lacks "bad stamp no error" "$out" "unbound"
echo $(( $(date +%s) - 8 * 86400 )) > .life/last-weekly-review
has "review due" "$(./life status)" "review: due (last 8 days ago)"
has "ritual offers due review" "$(./life ritual plan-day; ./life ritual)" "review: due (8 days)"
./life reviewed >/dev/null; has "review fresh" "$(./life status)" "review: not due (last 0 days ago)"

printf '# Current\n' > current.md
has "empty log fallback" "$(./life status)" "stopped: none yet"

# --- waiting-on ages
fresh setup
awk -v a="- Ana: form, since $TODAY" -v b="- Landlord, since $(days_ago 1)" \
    -v c="- Refund, since $(days_ago 15)" -v d="- Bank, no date" \
  '{print} /^## Waiting on/{print ""; print a; print b; print c; print d}' queue.md > q && mv q queue.md
out="$(./life status)"
has "age today" "$out" "w1 0 Ana: form, since $TODAY"
has "age 1" "$out" "w2 1 Landlord, since $(days_ago 1)"
has "age 15" "$out" "w3 15 Refund, since $(days_ago 15)"
has "age none" "$out" "w4 - Bank, no date"

# --- add
fresh setup
./life add 'pay \n bill & "rent" 50%' >/dev/null
./life add "$(printf 'two\nlines')" >/dev/null
q="$(cat queue.md)"
has "add keeps backslash" "$q" '- [ ] pay \n bill & "rent" 50% ('
has "add joins lines" "$q" "- [ ] two lines ($TODAY)"
has "add counted" "$(./life status)" "inbox 4"

printf '# Queue\n\n## Now\n\n## Inbox\n' > queue.md
./life add x >/dev/null; ./life add y >/dev/null
[ "$(tail -2 queue.md)" = "- [ ] x ($TODAY)
- [ ] y ($TODAY)" ] && ok || bad "add to last section" "$(cat queue.md)"

printf '# Queue\n\n## Now\n' > queue.md
out="$(./life add z 2>&1)"; rc=$?
[ $rc != 0 ] && ok || bad "add without Inbox should fail"
has "add without Inbox message" "$out" "no '## Inbox'"

# --- Windows line endings
fresh setup
crlf queue.md; crlf current.md
out="$(./life status)"
has "crlf stopped-at" "$out" '  at: `retry_test.go`, test case 3'
has "crlf now" "$out" "n1 Retry tests from case 3"
has "crlf inbox" "$out" "inbox 2"
./life done n1 >/dev/null && has "crlf done" "$(./life queue done)" "Retry tests from case 3" || bad "crlf done failed"
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
has "start has status" "$out" '  at: `retry_test.go`, test case 3'
has "start has context" "$out" "context:
  ## Who this is"
lacks "start no adhd when off" "$out" "ADHD mode"
touch .claude/.adhd-always
out="$(./life start)"
has "start adhd header" "$out" "ADHD mode is on"
has "start adhd rules" "$out" "First line is the next action"

# --- nudge (LIFE_NUDGE_DRY prints instead of notifying)
fresh setup
out="$(LIFE_NUDGE_DRY=1 ./life nudge)"
has "nudge names first Now item" "$out" "One thing today: Retry tests from case 3"
lacks "nudge no checkbox" "$out" "[ ]"
./life start >/dev/null
out="$(LIFE_NUDGE_DRY=1 ./life nudge)"
[ -z "$out" ] && ok || bad "nudge skips after a session today" "$out"
has "nudge test forces" "$(LIFE_NUDGE_DRY=1 ./life nudge test)" "One thing today"
echo "09:30 private" > .life/nudge
out="$(LIFE_NUDGE_DRY=1 ./life nudge test)"
lacks "nudge private hides item" "$out" "Retry"
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

# --- getting to know you (setup learns the rest one question a day)
fresh setup
lacks "no to-learn, no line" "$(./life status)" "Getting to know you"
cp .claude/skills/life-architect/to-learn.md .life/to-learn.md
has "first topic due" "$(./life status)" 'learn: t1 "Energy:'
has "learn names privacy-safe place" "$(./life learn)" 'write: context.md "How my brain works"' 
sed -i.bak "s/^Last asked: .*/Last asked: $TODAY/" .life/to-learn.md
lacks "asked today, quiet" "$(./life status)" "Getting to know you"
sed -i.bak -e "s/^Last asked: .*/Last asked: $(days_ago 1)/" -e 's/^- \[ \] Energy/- [x] Energy/' .life/to-learn.md
has "next topic after a tick" "$(./life status)" 'learn: t2 "Day shape' 
sed -i.bak 's/^- \[ \] /- [x] /' .life/to-learn.md
lacks "all learned, quiet" "$(./life status)" "Getting to know you"

# --- queue commands (ids are positions, recomputed every call)
fresh setup
has "queue lists ids" "$(./life queue)" "  x2 Draft the promotion write-up"
has "queue empty is definite" "$(printf '# Queue\n\n## Now\n\n## Next\n' > q2.md; cp queue.md q.bak; cp q2.md queue.md; ./life queue now; cp q.bak queue.md)" "now[0/3]: none"
out="$(./life move i1 next)"; has "move reports" "$out" "ok: i1 -> Next: Pay the BESCOM bill"
has "move lands at bottom" "$(./life queue next)" "x4 Pay the BESCOM bill"
out="$(./life done "passport")"; has "done by substring" "$out" "-> Done this week: Book the Passport Seva"
has "done is checked" "$(cat queue.md)" "- [x] Book the Passport Seva"
out="$(./life done "passport" 2>&1)"; has "done is idempotent" "$out" "already in Done this week"
out="$(./life done n9 2>&1)"; rc=$?
[ $rc = 2 ] && ok || bad "missing id exits 2" "$out"
has "missing id names the fix" "$out" "run: ./life queue"
out="$(./life done "e" 2>&1)"; has "ambiguous substring refused" "$out" "use an id"
out="$(./life move x1 nowhere 2>&1)"; has "unknown section refused" "$out" "unknown section 'nowhere'"
./life add --now "second thing" >/dev/null; ./life add --now "third thing" >/dev/null
out="$(./life now x1 2>&1)"; rc=$?
[ $rc = 2 ] && ok || bad "Now cap exits 2" "$out"
has "Now cap names the fix" "$out" "Now is full (3/3"
out="$(./life wait x1 "Meera")"; has "wait prefixes who and dates it" "$(./life queue waiting)" "Meera: Renew two-wheeler insurance (expires 8 Oct), since $TODAY"
./life plan x2 n1 >/dev/null
has "plan sets Now in order" "$(./life queue now)" "now[2/3]:
  n1 Appa's BP medicine refill"
has "plan displaces to top of Next" "$(./life queue next)" "x1 second thing"
[ "$(cat .life/last-plan)" = "$TODAY" ] && ok || bad "plan stamps last-plan"
awk 'prev ~ /^$/ && /^$/ { bad = 1 } { prev = $0 } END { exit bad }' queue.md && ok || bad "no double blank lines after moves" "$(cat -A queue.md)"
out="$(./life plan n1 n2 x1 x2 2>&1)"; has "plan caps at 3" "$out" "1 to 3 items"

# --- log (today's current.md entry)
fresh setup
out="$(./life log --stopped 'form page 3' --topic Admin --done 'paid BESCOM' --done 'odd \n chars' --energy 'low after commute')"
has "log adds today" "$out" "ok: log added for $TODAY"
c="$(cat current.md)"
has "log entry on top" "$(grep -m1 '^## 20' current.md)" "## $TODAY — Admin"
has "log keeps backslash" "$c" '- odd \n chars'
has "log keeps old entry" "$c" "## 2026-09-24 — Work: payment retries PR"
./life log --stopped "form page 4" --done "called Amma" >/dev/null
c="$(awk '/^## 20/{n++} n==1' current.md)"
has "log merges stopped" "$c" "Stopped at: form page 4"
has "log merges done" "$c" "- paid BESCOM"
has "log appends done" "$c" "- called Amma"
has "log keeps energy" "$c" "Energy: low after commute"
[ "$(grep -c "^## $TODAY" current.md)" = 1 ] && ok || bad "log merge keeps one entry"
./life log --new --topic "Weekly review" --done "win" >/dev/null
[ "$(grep -c "^## $TODAY" current.md)" = 2 ] && ok || bad "log --new adds a second entry"
has "log without stopped reminds" "$(./life log --done x 2>&1)" 'no "Stopped at" yet'
out="$(./life log --bogus 2>&1)"; has "log unknown flag" "$out" "unknown flag '--bogus'"
fresh setup
sed -i.bak "s/^## 2026-09-24/## $TODAY/" current.md
./life log --energy "better" >/dev/null
c="$(awk '/^## 20/{n++} n==1' current.md)"
has "merge keeps multi-line stopped" "$c" "The fixture needs a second merchant ID"
has "merge keeps working on" "$c" "Working on: the retry logic"
has "merge replaces energy" "$c" "Energy: better"

# --- therapy notes: private, write-only, count-only
fresh setup
has "therapy-note ok" "$(./life therapy-note 'the Appa thing')" "ok: noted"
./life therapy-note "second" >/dev/null
has "therapy note dated" "$(cat private/therapy-notes.md)" "- $TODAY: the Appa thing"
out="$(./life therapy-note --count)"; has "therapy count" "$out" "therapy_notes_this_week: 2"
lacks "therapy count never shows content" "$out" "Appa"
git init -q . && printf 'nothing\n' > .gitignore
out="$(./life therapy-note "x" 2>&1)"; rc=$?
[ $rc = 2 ] && ok || bad "therapy-note refuses when private/ is not ignored" "$out"

# --- ritual routing
fresh setup
has "ritual prints a file" "$(./life ritual)" "file: .claude/rituals/"
has "ritual by name" "$(./life ritual wrap-up)" "# Ritual: wrap up the day"
echo "00:00" > .life/midpoint; has "after midpoint wraps up" "$(./life ritual)" "ritual: wrap-up"
echo "23:59" > .life/midpoint; has "before midpoint plans" "$(./life ritual)" "ritual: plan-day"
out="$(./life ritual bogus 2>&1)"; has "unknown ritual" "$out" "unknown ritual 'bogus'"

# --- learned / skip rules
fresh setup
cp .claude/skills/life-architect/to-learn.md .life/to-learn.md
has "learned skip" "$(./life learned t1 --skip)" "skipped"
has "skip counts as asked today" "$(./life learn)" "already asked today"
sed -i.bak "s/^Last asked: .*/Last asked: $(days_ago 1)/" .life/to-learn.md
has "second skip drops" "$(./life learned t1 --skip)" "dropped after two skips"
out="$(./life learned t99 2>&1)"; has "unknown topic" "$out" "no topic t99"

# --- help is agent-first
has "help lists ids" "$(./life help)" "Ids: n1 = first Now item"
out="$(./life frob 2>&1)"; rc=$?
[ $rc = 2 ] && ok || bad "unknown command exits 2"

# --- Claude Code hook runs the same command
fresh
hook="$(awk -F'"command": "' 'NF > 1 {sub(/",$/, "", $2); print $2}' .claude/settings.json | sed 's/\\"/"/g')"
out="$(CLAUDE_PROJECT_DIR="$T" sh -c "$hook")"
has "hook runs life start" "$out" "Not set up yet"

echo "life tests: $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ]
