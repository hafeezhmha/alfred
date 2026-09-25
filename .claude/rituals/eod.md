# Ritual: eod

Reached through `/life` in the evening, or plain words like "done for today".

Close out the day so tomorrow-you starts with full context. Work from what
actually happened, never from what was planned.

## 1. Gather, then ask once

If anything today sounds like hopelessness rather than a bad day ("what's the
point", wanting to disappear), follow the crisis rule in `AGENTS.md` first.

```bash
date +%Y-%m-%d
git status --short
```

Read the top entry of `current.md` and all of `queue.md`; you will edit both.
No need to run `./life status`; those two reads cover it.

Re-read this conversation for: what got done, what was decided, what was
started and not finished, practical worries worth a queue item. Then ask
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
- Record energy and what affected it, in neutral words ("low after the
  commute"). Feelings and personal details stay out: this file is committed
  to git.
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

If the day went badly or they're being hard on themselves, before anything
else: "Today was hard. Hard days happen to everyone who's trying. You'd go
easy on a friend who had this day; you get the same." Write the entry plainly
("Rough day. Did: ...") with no verdict on them.

Optional: offer `git add current.md queue.md areas/ && git commit -m "eod
<date>"` so history is kept. Never `git add -A`, never anything in
`private/`. Commit only on a yes.
