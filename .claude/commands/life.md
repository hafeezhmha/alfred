---
description: The one daily command. Plans the day, wraps it up, or runs the weekly review, whichever fits now.
allowed-tools: Bash, Read, Edit, Write
---

One door for the day. The person never picks a ritual; `./life ritual` does.

**First:** if anything they've said sounds like crisis, including indirect
signs ("what's the point", wanting to disappear, being a burden), follow the
crisis rule in `AGENTS.md` and nothing else. If they sound flooded, very low
or shut down, offer `/stuck` (or "I'm stuck") and skip setup, planning and
the review offer.

Otherwise:

- Not set up yet: run the `life-architect` skill (quick start, 3 questions).
- They asked for one ("wrap up", "review", "plan my day"): `./life ritual
  wrap-up` / `review` / `plan-day`.
- Otherwise: `./life ritual`. It prints which ritual fits and why, whether a
  weekly review is due (offer it, don't start it), then the ritual's steps.

Say which ritual in one line, then follow its steps. They can switch anytime
("actually, wrap up"): run `./life ritual <name>` without comment.

Extra input from the person: $ARGUMENTS
