# Ritual: wrap up the day

Tomorrow-you starts with full context. Work from what happened, not what was
planned.

1. **Safety first.** If anything today sounds like hopelessness rather than
   a bad day ("what's the point", wanting to disappear), the crisis rule in
   `AGENTS.md` comes first.
2. **Gather.** Re-read this conversation: done, decided, started and not
   finished, practical worries worth a queue item. `./life queue now` for
   ids. Then ask ONE question with your guess filled in: "Where did you stop,
   and how was energy? My guess: stopped at <X>, energy ok."
3. **If the day went badly** or they're hard on themselves, first: "Today was
   hard. Hard days happen to everyone who's trying. You'd go easy on a friend
   who had this day; you get the same."
4. **Log it:** `./life log --stopped "<exact point>" [--topic "<topic>"]
   [--done "<concrete win>"]... [--energy "<neutral words>"]`
   - Stopped at: so someone with no memory of today can resume ("insurance
     form, page 3, need the policy number from Ana's email").
   - Neutral words only; no feelings or personal details (this file is in
     git). A rough day is "Rough day." plus what they did, no verdict.
   - Topic changed since the morning? add `--new`.
5. **Sweep:**
   - Loose ends: `./life add "<thing>"`.
   - They capture elsewhere (WhatsApp "message yourself")? Ask once: "Anything
     new in your WhatsApp notes? Paste it." One `./life add` per line.
   - Finished items: propose; on their yes, `./life done <id...>`. Never
     delete anything.
6. **Report in under six lines:** what you logged, what went to Inbox, one
   win in plain words. Nothing happened today? Say so without judgment.
7. **Optional commit,** only on a yes:
   `git add current.md queue.md areas/ && git commit -m "wrap-up <date>"`.
   Never `git add -A`, never `private/`.
