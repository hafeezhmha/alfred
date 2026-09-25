<div align="center">

```
          .
       .-' '-.
     .'   |   '.
    /  \  |  /  \              _     _  __         ___  ____
   |  \ \ | / /  |            | |   (_)/ _| ___   / _ \/ ___|
   |   \ \|/ /   |            | |   | | |_ / _ \ | | | \___ \
   | \  \ | /  / |            | |___| |  _|  __/ | |_| |___) |
    \ \  \|/  / /             |_____|_|_|  \___|  \___/|____/
     '.\  |  /.'
       '-.|.-'
          |
          |
         /
```

**A little operating system for your life, run by an AI agent.**

For brains that zig, zag, hyperfocus, freeze, forget, and start again.
Plain text you own. Nothing to install but the agent.

</div>

---

> [!TIP]
> **Short on time or focus? Read only this box.**
> Make a private copy, open it in Claude Code, type `/life-architect`.
> It interviews you (about 20 minutes, pausable) and builds the rest.
> Every session after that opens with where you stopped and one tiny next step.

---

## Is this for you?

Maybe, if any of these sound familiar:

- You have started more planners than you have finished.
- "Where was I?" costs you the first hour of every day.
- A list of 40 overdue things makes you close the app and never open it again.
- You know exactly what to do. Doing it is a different sport.
- You'd love a system, but not one that needs its own system to maintain.

Life OS was built with ADHD, autistic and otherwise neurodivergent brains in
mind from the first line. It works for everyone else too; they just get fewer
of the jokes.

## Start here (3 steps, about 20 minutes)

1. **Make your own copy.** On GitHub, click "Use this template". Set it to
   **private**: it will hold your life. Clone it.
2. **Open it.** In a terminal: `cd life-os && claude`
3. **Type `/life-architect`.** It asks a few questions at a time, each with an
   answer you can just accept, then writes your files for you.

You can say "pause" at any point. It saves and picks up later.

<details>
<summary><b>Using OpenCode or Codex instead?</b> (same system, one small difference)</summary>

<br>

All three agents read the same `AGENTS.md` and start every session with one
call to `./life start`, so nothing gets loaded twice.

- **OpenCode:** `cd life-os && opencode`, then `/life-architect`.
- **Codex:** `cd life-os && codex`, then say "set up my life os". Codex has no
  `/` commands here, so ask in plain words: "start my day", "wrap up",
  "weekly review", "I'm stuck", "grill me on this".

The one difference: neither has a start-of-session hook, so your status
appears after your first message instead of before it. Saying "hi" is enough.

</details>

<details>
<summary><b>What you need</b> (probably already have most of it)</summary>

<br>

- [Claude Code](https://claude.com/claude-code), [OpenCode](https://opencode.ai)
  or Codex, with a model account.
- macOS or Linux, same steps on both. On a new Mac, `git` asks to install the
  Command Line Tools the first time; say yes. On Windows, use WSL.
- Git, and a GitHub account to hold your private copy.

</details>

## What a morning looks like

You open your agent. Before you've typed anything, it says something like:

> Hi Sam,
> you stopped at IAM video 5, at 12:40 ("Policies"); the practice quiz isn't started.
> The council tax refund has been waiting 15 days.
>
> **First step (2 min):** open the course and press play at 12:40.

That's it. No dashboard. No streak. No red numbers. One door, already open.

## The spells

Type these in Claude Code or OpenCode (or say them in plain words in Codex).

| Say | When | What happens |
|---|---|---|
| `/start-day` | the day begins | Asks your energy, picks 1 to 3 things, names the first two-minute step. |
| `/eod` | the day ends | Writes down exactly where you stopped, so tomorrow-you doesn't have to remember. |
| `/unstuck` | frozen, overwhelmed, avoiding | Finds what's blocking you and shrinks the step until you can start. |
| `/weekly-review` | once a week, ~20 min | Wins first, then empty the inbox, check your areas, pick next week's focus. |
| `/grill-me` | before a big decision | Asks the questions you'd rather skip, until the decision is actually settled. |
| `/life-architect` | first run, or life changed | The setup interview. Run it again whenever things shift. |
| `/i-have-adhd` | anytime | Shapes every reply for an ADHD brain. Setup can make it always on. |

And one from the terminal, for the thought that arrives mid-shower:

```
./life add "call the dentist about the thing"
```

It lands in your Inbox. Sorting it is a job for later-you.

### A tap on the shoulder

Out of sight, out of mind is real. If you'd like one, Life OS can send a
single desktop notification each day:

```
./life nudge on 09:30
```

> Life OS: One thing today: IAM video 5 from 12:40. Open your agent and say hi.

It only shows up on days you haven't opened Life OS yet. No counts, no "you
missed", no second ping. Add `private` to keep your task off the lock screen,
and `./life nudge off` stops it. Setup offers it too, so you may never need to
type this.

## Promises this system keeps

- **You stop being the memory.** Where you stopped, what's open and who you're
  waiting on live in files. The agent reads them, so you don't have to.
- **One next step, always.** Never a wall of options. Always something doable
  in under two minutes.
- **No shame, ever.** Missed a day? A week? A month? Nothing is "behind". The
  next session starts from today. The agent is not allowed to say "you should
  have", "just", or "simply".
- **Small beats complete.** At most 3 things in Now. On a low-energy day, 1
  thing counts as a full day.
- **Energy before time.** Hard things go where your brain is actually sharp.
- **Built around you.** The setup asks how your brain works and what killed
  your last five systems, then designs against exactly that.
- **Your call, always.** It suggests with options; you decide. It never sends,
  books, buys or deletes anything without your yes, each time.
- **It's yours.** Plain markdown in a git repo. Switch agents, or stop using
  it; your history stays readable forever.

## What's in the box

<details>
<summary><b>The files, and what each one is for</b></summary>

<br>

| File / folder | What it does |
|---|---|
| `context.md` | Your life map: areas, people, commitments, how your brain works. Changes rarely. |
| `current.md` | Where you stopped, newest first. Old entries tidy themselves into `archive/` weekly. |
| `queue.md` | Open loops: Now (max 3), Next, Waiting on, Inbox, Someday, Done this week. |
| `areas/` | One folder per life area (health, money, work...) with its goals and decisions. |
| `archive/` | Old plans and old log entries. Kept, never nagged about. |
| `private/` | Git-ignored. For anything you'd never want on a server. |
| `AGENTS.md` | The rules the agent follows with you, every session, in every agent. |
| `CLAUDE.md` | Tiny pointer so Claude Code finds `AGENTS.md`. |
| `.opencode/commands/` | Makes the same `/` commands work in OpenCode. |
| `examples/sam/` | A filled-in example, so you can see what "set up" looks like. |

</details>

<details>
<summary><b>The <code>./life</code> launcher</b> (you rarely need it; the agent runs it)</summary>

<br>

```
./life start      everything an agent needs at session start, in one go
./life status     where you stopped, Now, Waiting on (with how many days), inbox count
./life add "..."  capture a thought to the Inbox
./life archive    move log entries older than 4 weeks into archive/
./life reviewed   mark the weekly review done
./life check      spot missing files or unfilled setup placeholders
./life nudge      daily desktop nudge: on HH:MM [private], off, or test
```

</details>

<details>
<summary><b>Where this came from</b> (for the curious)</summary>

<br>

Life OS is a real AI-native software workflow, repointed at a life. The same
files and rituals that let an agent pick up a codebase cold every morning turn
out to be very good at picking up a person.

| In the software workflow | In Life OS |
|---|---|
| Workspace contract (`AGENTS.md`) | How the agent treats you |
| Workspace map | `context.md`, your life map |
| Session log | `current.md`, where you stopped |
| Task tracker | `queue.md`, or a pointer to Todoist, Notion, etc. |
| Launcher `status` | `./life start` at session start |
| Grill before building a feature | Grill before a big life decision |
| End-of-day handoff | `/eod` |
| Never touch prod without approval | Never send, book, buy or delete without your OK |

</details>

---

## Privacy

Your copy will hold health, money and relationship details. **Keep the repo
private.** Put anything you'd never want on a server in `private/`; git
ignores that folder. During setup you can skip any question, and sensitive details are only
written down if you agree.

## Sharing with friends

Share **this template**, never your filled-in copy. Each friend makes their own
copy and runs `/life-architect`; nothing of yours travels with it.

## Not therapy

This is an organising tool. It doesn't diagnose anything, and it isn't a
substitute for a doctor, therapist or coach.

> [!IMPORTANT]
> If you're in crisis, please reach out now.
> **India:** Tele-MANAS, call **14416** (free, 24/7, in English and 20 Indian
> languages). Emergency: **112**.
> **Elsewhere:** local emergency services, or US **988**, UK Samaritans **116 123**.

## Changing the template

Ideas and fixes are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) first:
it's the short checklist that keeps this system kind to the brains it's for.

## License

MIT. Vendored skills keep their own MIT credits; see `NOTICE.md`.

---

<div align="center">

*Leaves fall, and grow back every spring. Restarting is the skill.*

</div>
