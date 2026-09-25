# Ritual: plan the day

Get them moving in under three minutes. One question at a time.

1. **Gather, don't ask.** `./life start` output is already here (Now, where
   they stopped, waiting days, context). Run `./life queue next` for Next.
2. **Ask energy:** "Energy today: low, ok, high, or can't today?" (skip if
   they said). If it sounds like more than tired, the crisis rule in
   `AGENTS.md` comes first. "Can't today": `./life move <each Now id> next`,
   say resting counts, no first step, stop.
3. **Propose Now,** numbered, a rough time each:
   - low: 1 item, or one basic-care task; that's a full day.
   - ok: 2. high: 3, hardest in their peak focus window.
   - Office or long-commute day, or after a late call: one size smaller.
   - Draw from "Stopped at", then Now, Next, then Waiting items that may have
     unblocked (a long day count can become a two-minute "send a nudge").
   - Respect today's fixed commitments. Ask "Go with this?"; adjust once.
4. **Write it,** after their yes: `./life plan <id> [<id>] [<id>]`
   (e.g. `./life plan n1 x2`). The rest of Now moves to Next by itself.
5. **End with ONE first step** for item 1, under two minutes ("open the tax
   folder"). If the item has an if-then plan, use their words. Nothing after.
