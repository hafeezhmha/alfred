<div align="center">

```
                    __
               _.-'` /
           _.-'    .'|
        .-'     .-'  |       l i f e   o s
      .'     .-'     /       -------------
     /    .-'      .'        a little operating
    |  .-'      _.'          system for your life
    |.'    _.-'`
    /_.--'`
   /
```

**Run by an AI agent, for brains that zig, zag, hyperfocus, freeze, forget,
and start again.**

Plain text you own. Nothing to install but the agent.

</div>

---

> [!TIP]
> **Short on time or focus? Read only this box.**
> Make a private copy, open it in Claude Code, type `/life`.
> Three questions, about three minutes, and it works. It learns the rest one
> small question a day. Every session opens with where you stopped and one
> tiny next step.

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

## Start here (about 3 minutes)

1. **Make your own copy.** On GitHub, click "Use this template". Set it to
   **private**: it will hold your life. Clone it.
2. **Open it.** In a terminal: `cd life-os && claude`
3. **Type `/life`.** Three questions: what to call you, one thing that keeps
   slipping, and whether you'd like ADHD-shaped replies. That's setup.

No 30-minute interview before anything works. Over the next couple of weeks
it asks one small question at the end of a session (energy, people, your
week), always skippable, and fills in your life map as it goes.

Prefer to do it all in one sitting? Say "full setup" any time: a guided
interview, pausable, and it can show its proposal as a page you click
through and mark up. (Pages need Node.js. Text works just as well.)

<details>
<summary><b>Using OpenCode or Codex instead?</b> (same system, one small difference)</summary>

<br>

All three agents read the same `AGENTS.md` and start every session with one
call to `./life start`, so nothing gets loaded twice.

- **OpenCode:** `cd life-os && opencode`, then `/life`.
- **Codex:** `cd life-os && codex`, then say "set up my life os". Codex has no
  `/` commands here, so just say it: "plan my day", "wrap up", "I'm stuck".

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

> Hi Kavya,
> you stopped at `retry_test.go`, test case 3 of 5; the fixture needs a second merchant ID.
> The HR broadband reimbursement has been waiting 23 days.
>
> **First step (2 min):** open `fixtures/merchants.json` and copy the second merchant ID.

That's it. No dashboard. No streak. No red numbers. One door, already open.

## The spells

Only three to remember. Or none: plain words work too, in every agent.

| Type | Or just say | What happens |
|---|---|---|
| `/life` | "plan my day", "wrap up", "weekly review" | Whatever fits right now. Morning: asks your energy, picks 1 to 3 things, names a two-minute first step. Evening: writes down exactly where you stopped. Once a week: a review, 2-minute version first. |
| `/stuck` | "I'm stuck", "I'm overwhelmed" | One question: is it the task, or the feelings? Then the right help: shrink the step until you can start, or pause, settle and pick one small thing. Every step skippable. |
| `/grill-me` | "grill me on this" | Asks the questions you'd rather skip, until a big decision is actually settled. |

"adhd mode on" and "stop adhd mode" work anytime too.

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

> Life OS: One thing today: Retry tests from case 3. Open your agent and say hi.

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
- **Skills, not therapy.** When feelings run the show, it offers small,
  well-researched skills (from DBT, ACT and self-compassion work) and stays
  in the present. If you have a therapist, their plan comes first, and it
  can keep a private list of things to bring to them. Like talking in parts
  ("a part of me doesn't want to")? It can too, gently, the IFS way, with
  the names you already use.
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
| `.claude/` | The three commands, the rituals they run (`rituals/`), and the skills behind them. |
| `.opencode/commands/` | Makes the same `/` commands work in OpenCode. |
| `examples/kavya/` | A filled-in example (a developer in Bangalore), so you can see what "set up" looks like. |

</details>

<details>
<summary><b>The <code>./life</code> launcher</b> (you rarely need it; the agent runs it)</summary>

<br>

Built for AI agents first (the [AXI](https://axi.md/) idea): short, structured
output, items with ids like `n1` or `x2`, and every answer ends with what to
run next. The agent edits your files through it, so dates and formats come
out right even with a smaller model. Your files stay plain markdown you can
edit by hand.

```
./life                 where you stopped, Now, waiting, what's due
./life add "..."       capture a thought to the Inbox
./life queue           everything, with ids
./life done n1         mark done        ./life move i2 next   move things
./life plan n1 x2      set today's Now  ./life wait x1 "Ana"  waiting on someone
./life log --stopped "page 3 of the form"   today's "where I stopped"
./life ritual          which ritual fits right now, and its steps
./life nudge on 09:30  a daily desktop nudge
./life help            everything else
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
| End-of-day handoff | Wrap-up (`/life` in the evening) |
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
copy and types `/life`; nothing of yours travels with it.

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
