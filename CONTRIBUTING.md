# Changing the template

ALFRED is for neurodivergent brains first. Every change, however small, gets
checked against this list. If a change fails one, it needs a very good reason.

## The brain checklist

- **Fewer things to hold.** Does it add something the person has to remember?
  Then the system should remember it instead.
- **One next step.** Every flow still ends in one concrete action doable in
  under two minutes.
- **Starting stays cheap.** No new setup, no new daily chore, no new place to
  check. A 2-minute version beats a 20-minute one. Setup stays at three
  questions; anything else is learned one question a day.
- **Few doors.** Three commands: `/life`, `/stuck`, `/grill-me`. New
  behaviour goes behind one of them, or behind plain words, as a ritual in
  `.claude/rituals/`. Never add a fourth command without removing one.
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
- **Skills, not therapy.** Emotional features use small skills with research
  behind them (DBT, ACT, CBT, self-compassion, behavioural activation), stay
  in the present, never diagnose, and never go into memories or trauma. Say
  honestly when evidence is thin.

## The engineering checklist

- **Works in Claude Code, OpenCode and Codex.** Behaviour lives in `AGENTS.md`
  and the shared ritual files, not in one agent's config. Codex has no project
  `/` commands and runs hooks only once the person trusts them (`/hooks`);
  OpenCode has no hooks. So every ritual needs a plain-words path, and
  every hook duty a written rule in `AGENTS.md` as well.
- **Lean context.** Session start is one call to `./life start`. Don't make an
  agent read the same content twice, and weigh every byte added to
  `AGENTS.md` or the start output: it is paid every session.
- **Plain bash, portable.** `life` must run on macOS (bash 3.2, BSD awk) and
  Linux. No `date -d`, no gawk-only functions. The one exception is the
  optional page, `.claude/page.py`: Python 3.8+, standard library only,
  loopback only, and it writes only by running `./life`.
- **Copies update by `./life update`.** Code paths it copies are listed in
  `UPDATE_CODE` in `life`; data files are never overwritten. A new data
  file needs a template version that's safe to add to an old copy.
- **Two copies of the ADHD rules.** `.claude/skills/i-have-adhd/always-on.md`
  is the short form of `SKILL.md` there, printed every session. Keep the
  two in step when upstream changes.
- **Agent-first CLI (AXI).** File edits go through `./life` commands: compact
  output, ids, a `next:` hint, errors on stderr with exit 2 that name the
  fix. Markdown stays the source of truth; nothing is stored beside it. The
  CLI never decides for the person, and crisis handling stays in prose.
- **Tested.** Add a check to `.github/tests/life.sh` for any launcher change,
  and run `bash .github/tests/life.sh` before committing.

## Core and optional

One maintainer, many surfaces. When something has to give, the core keeps
working and the optional parts can be removed cleanly.

- **Core:** `AGENTS.md`, `life` (queue, log, week, review, gate, safety,
  setup, backup, update), the rituals, `life-architect`, `/life`, `/stuck`,
  the Claude Code and Codex hooks.
- **Optional:** the page (`.claude/page.py`), the nudge, `lavish`,
  `grill-me`, `phone.md`, the bench.
