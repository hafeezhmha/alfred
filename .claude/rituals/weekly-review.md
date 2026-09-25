# Ritual: weekly review

Calm and short. Start every message with progress, e.g. `Weekly review · step
2 of 5 · ~12 min left`. 2-minute version (they ask, or their notes say so):
step 2 only. If their notes say "pages: yes", offer once to show steps 1 and
3 as a page (`lavish`).

1. **Wins first.** `./life queue done`, plus this week's `current.md`
   entries. Show wins as a short list. Thin list? Find real ones in the log;
   getting through a hard week counts.
2. **Empty the Inbox.** `./life queue inbox`. For each item propose Now /
   Next / Waiting / Someday / drop, in batches of up to 5 so they can say
   "all yes". On their yes: `./life move i1 i3 next`, `./life wait i2 "who"`,
   and so on. "Drop" means Someday unless they say delete; never delete
   anything they didn't confirm.
3. **Areas and load.** One line per `areas/<area>/README.md`: still the right
   focus? Skip any they don't want to look at, without comment. Then: "How
   full was the tank this week? Social, sensory, masking, family: light, ok,
   or heavy?" Heavy two weeks running: plan next week lighter, never "push
   through". Exhaustion rest doesn't fix, or skills slipping: "That sounds
   really heavy. A doctor or counsellor can help work out what's going on."
   No labels. Hopelessness: the crisis rule in `AGENTS.md` comes first.
4. **The system.** "Anything here you're ignoring or that feels like a
   chore?" A ritual or area skipped two weeks: offer to shrink, move or drop
   it. Nudge on (`.life/nudge`) but ignored: offer a new time or
   `./life nudge off`. Things stale? Offer one small refresh.
5. **Next week.** At most 3 focus items, plus fixed commitments that change
   the week's shape. "Does this point at what matters to you, or only at
   what's loud?"
   - `./life therapy-note --count`: if it's more than 0, say only "N things
     noted for your therapist". Skip this entirely if their notes say others
     see their screen. Never read the notes.
   - Log it: `./life log --new --topic "Weekly review" --done "<win>"...
     --stopped "next week's focus: <a>, <b>"`.
   - Then delete the "Done this week" lines from `queue.md` (they're kept in
     that log entry).
   - Run `./life reviewed` then `./life archive`. Mention the archive in one
     line only if it moved anything.
   - End with the first action for Monday, under two minutes.
