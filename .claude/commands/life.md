---
description: The one daily command. Plans the day, wraps it up, or runs the weekly review, whichever fits now.
allowed-tools: Bash, Read, Edit, Write
---

One door for the day. The person should never have to pick a ritual.

**First:** if anything they've said sounds like crisis, including indirect
signs ("what's the point", wanting to disappear, being a burden), follow the
crisis rule in `AGENTS.md` and nothing else. If they sound flooded, very low
or shut down, offer `/stuck` (or "I'm stuck") and skip setup, planning and
the review offer.

Otherwise use the session-start output already in this conversation (run
`./life start` only if it is missing), then choose, say which in one line,
and go:

1. `.life/SETUP_NEEDED` exists: run the `life-architect` skill (its quick
   start takes about 3 minutes).
2. They asked for something ("wrap up", "review", "plan my day"): do that.
3. The status says a weekly review is due and it's their review day (see
   "About the person"), or it's been 10+ days: offer, don't start: "Weekly
   review is due. 2-minute version now, the full one, or later?"
4. Otherwise go by their day, using the ritual times in "About the person"
   if set: before their day's midpoint (default 15:00) plan the day; after
   it, wrap up. If today's Now was already planned and it's late, wrap up.

Then read the matching file and follow it:

| Ritual | File |
|---|---|
| Plan the day | `.claude/rituals/start-day.md` |
| Wrap up | `.claude/rituals/eod.md` |
| Weekly review | `.claude/rituals/weekly-review.md` |

They can switch anytime ("actually, wrap up"); switch without comment. If
they sound flooded or stuck, offer `/stuck` (or "I'm stuck") instead.

Extra input from the person: $ARGUMENTS
