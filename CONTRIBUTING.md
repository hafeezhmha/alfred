# Changing the template

Life OS is for neurodivergent brains first. Every change, however small, gets
checked against this list. If a change fails one, it needs a very good reason.

## The brain checklist

- **Fewer things to hold.** Does it add something the person has to remember?
  Then the system should remember it instead.
- **One next step.** Every flow still ends in one concrete action doable in
  under two minutes.
- **Starting stays cheap.** No new setup, no new daily chore, no new place to
  check. A 2-minute version beats a 20-minute one.
- **No shame, no scoreboards.** No streaks, scores, red "overdue" lists or
  "you missed" framing. Counts are neutral ("waiting 15 days"), never
  reproachful. Missed days restart from today.
- **Choices, not orders.** Suggestions come with a recommendation plus one or
  two real alternatives. The person decides.
- **Predictable shape.** Rituals keep the same steps in the same order.
  Autistic users rely on that; ADHD users get novelty from content, not
  from the structure moving.
- **Easy to read.** Short lines, short blocks, plain words, concrete time
  estimates. No idioms, no walls of text. Detail goes behind a fold.
- **Accessible decoration.** Whimsy lives in the voice and the ASCII, not in
  emoji or symbols a screen reader will read aloud.
- **Safety beats flow.** Crisis rules, "never act outward without a yes" and
  "never delete without a yes" are never softened for convenience.

## The engineering checklist

- **Works in Claude Code, OpenCode and Codex.** Behaviour lives in `AGENTS.md`
  and the shared ritual files, not in one agent's config. Codex has no project
  `/` commands or hooks, so every ritual needs a plain-words path.
- **Lean context.** Session start is one call to `./life start`. Don't make an
  agent read the same content twice, and weigh every byte added to
  `AGENTS.md` or the start output: it is paid every session.
- **Plain bash, portable.** `life` must run on macOS (bash 3.2, BSD awk) and
  Linux. No `date -d`, no gawk-only functions.
- **Tested.** Add a check to `.github/tests/life.sh` for any launcher change,
  and run `bash .github/tests/life.sh` before committing.
