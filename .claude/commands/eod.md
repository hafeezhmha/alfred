---
description: End of day. Write where you stopped into current.md and sweep loose ends into the queue.
allowed-tools: Bash, Read, Edit, Write
---

Close out the day so tomorrow-you starts with full context. Work from what
actually happened, never from what was planned.

## 1. Gather, then ask once

```bash
date +%Y-%m-%d
git status --short
```

Read the top entry of `current.md` and all of `queue.md`; you will edit both.
No need to run `./life status`; those two reads cover it.

Re-read this conversation for: what got done, what was decided, what was
started and not finished, anything they said they're worried about. Then ask
ONE question, with your guess filled in so they can just say "yes":

> "Where did you stop, and how was energy? My guess: stopped at <X>, energy
> ok."

## 2. Rewrite the top entry of `current.md`

If today already has an entry, rewrite it in place. If the topic changed, add
a new dated entry above. Match the shape at the top of `current.md`:

- **Stopped at** is the most valuable line. Write it so someone with no memory
  of today can pick up: "halfway through the insurance form, page 3, need the
  policy number from the email from Ana" beats "made progress".
- Record what was done, concretely. Small wins count and go in.
- Record energy and anything that affected it.
- Keep it under about 15 lines. Detail belongs in `areas/<area>/`.

## 3. Sweep the queue

- Anything mentioned today but not done goes to Inbox.
- If they capture somewhere else (WhatsApp "message yourself", a notes app),
  ask once: "Anything new in your WhatsApp notes? Paste it." Each line goes
  to Inbox. Skip if they say no.
- Finished items: propose moving them to "Done this week". Move only what the
  person confirms.
- Never delete an item.

## 4. Report in under six lines

What you wrote, how many items went to Inbox, and one win from today in
plain words. If nothing happened today, say that without judgment and write
only a one-line entry if they want one.

Optional: offer `git add -A && git commit -m "eod <date>"` so history is
kept. Commit only on a yes.
