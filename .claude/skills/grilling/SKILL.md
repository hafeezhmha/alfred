---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, faces a big life decision, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (files in this repo, the web, etc.), look it up yourself; don't ask the user for anything you could look up. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.

## Life OS notes (added by this template, not upstream)

- **Cap each round at 3 questions** when `.claude/.adhd-always` exists or the
  person's notes in `AGENTS.md` say rounds should be short. Hold the rest of
  the frontier for the next round.
- Start each round with one line of progress, e.g. `Round 2 · 4 decisions
  settled · ~3 left`.
- Life decisions have feelings attached. Ask about the feeling when it is a
  real input ("how would you feel telling your manager?"), not as therapy.
- For a big, many-branched decision, and if their notes say "pages: yes",
  offer once to draw the decision tree as a page (`lavish`, diagram
  playbook): settled branches, open ones, and your recommendation on each.
- When done, write the settled decision to the relevant
  `areas/<area>/README.md` under "Decisions", and follow-up actions to the
  Inbox in `queue.md`, before anyone acts.

Source: [mattpocock/skills](https://github.com/mattpocock/skills/tree/main/skills/productivity/grilling), MIT. Re-fetch to update.
