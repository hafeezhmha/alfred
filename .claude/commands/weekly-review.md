---
description: Weekly review, about 20 minutes. Empty the inbox, check each area, pick next week's focus.
allowed-tools: Bash, Read, Edit, Write
---

Run a calm, short review. Show progress at the top of every message, e.g.
`Weekly review · step 2 of 5 · ~12 min left`. If their notes say "pages:
yes", offer once to show steps 1 and 3 as a page (`lavish`): wins and areas
at a glance, marked up by clicking. If the person wants the
2-minute version (or their AGENTS.md notes say so), do only step 2.

## 1. Wins first (2 min)

Read "Done this week" in `queue.md` and the week's `current.md` entries. Show
the wins as a short list. If the list is thin, find real ones in the log;
getting through a hard week counts.

## 2. Empty the Inbox (5 min)

For each Inbox item, propose one of: Now / Next / Waiting on / Someday /
drop. Batch them in groups of up to 5 so they can answer "all yes" or
correct one. Move only what they confirm.

## 3. Check each area (5 min)

For each `areas/<area>/README.md`, one line: still the right focus? Anything
stuck? Skip areas they don't want to look at this week, without comment.

## 4. Check the system (3 min)

Ask one question: "Anything in this system you're ignoring or that feels like
a chore?" If a ritual or area has been skipped for two weeks, offer to shrink,
move, or drop it. If a nudge is on (`.life/nudge` exists) and they've been
ignoring it, offer a new time or `./life nudge off`. Offer one small refresh if things feel stale (novelty
matters).

## 5. Next week (3 min)

Pick at most 3 focus items for next week and note fixed commitments that
change the shape of the week. Clear "Done this week" into a new
`## YYYY-MM-DD — Weekly review` entry at the top of `current.md` (wins, next
week's focus). Then run:

```bash
./life reviewed
./life archive
```

`./life archive` moves `current.md` entries older than four weeks to
`archive/current-YYYY.md`, so the log stays short enough to read. It only
moves, never deletes. Mention it in one line only if it moved anything.

End with the first action for Monday, under two minutes.
