# Life OS

A personal operating system for your life, run with an AI agent (Claude Code,
Codex, or any assistant that reads `AGENTS.md`).

It is built from a real AI-native software workflow: the same files and rituals
that let an agent pick up a codebase cold every morning, repointed at a life.
Nothing to install beyond the agent. It is all plain text you own.

## What you need

- [Claude Code](https://claude.com/claude-code) or [OpenCode](https://opencode.ai), with a model account (Claude plan, API key, or any provider OpenCode supports).
- macOS or Linux, same steps on both. On a new Mac, `git` asks to install the Command Line Tools the first time; say yes. On Windows, use WSL.
- Git, and a GitHub account to hold your private copy.

## Start in 3 steps (about 20 minutes)

1. Use this template to create your own repo on GitHub, and **make it
   private** (it will hold your life). Clone it.
2. Open the folder in Claude Code: `cd life-os && claude`
3. Type `/life-architect`. It interviews you, suggests a system that fits your
   life, and writes the files for you.

### Using OpenCode or Codex instead

Same files, same behaviour. All three agents read `AGENTS.md` (Claude Code
through `CLAUDE.md`), and every session starts with one call to
`./life start`, so nothing is loaded twice.

- **OpenCode:** `cd life-os && opencode`, then `/life-architect`. The `/`
  commands live in `.opencode/commands/` as thin pointers to the same files.
- **Codex:** `cd life-os && codex`, then say "set up my life os". Codex has no
  project `/` commands, so ask in plain words: "start my day", "wrap up",
  "weekly review", "I'm stuck", "grill me on this".

Neither has a start-of-session hook, so your status appears after your first
message rather than before it. Saying "hi" is enough.

## Why bother

- **You stop being the memory.** Where you stopped, what's open, and who you're
  waiting on live in files. The agent reads them at the start of every session
  and tells you. Nothing depends on remembering.
- **Starting gets easy.** Every session opens with one small next action, not a
  wall of options.
- **It fits you, not a productivity influencer.** The setup interview asks how
  your brain works, what you've tried and dropped, and why, then designs around
  that.
- **Big decisions get stress-tested.** `/grill-me` interviews you until a
  decision's loose ends are settled, before you commit.
- **Built with ADHD and neurodivergent brains in mind.** Short rounds,
  recommended answers you can just accept, no shame language, capture in one
  command, and a rescue command for when you're frozen.
- **It's yours.** Plain markdown in a git repo. Switch agents, tools, or stop
  using it; your history stays readable.

## What's inside

| File / folder | What it does |
|---|---|
| `AGENTS.md` | The operating contract. How the agent behaves with you, every session. |
| `CLAUDE.md` | Entry point so Claude Code finds `AGENTS.md`. |
| `context.md` | Your life map: areas, people, commitments, constraints. Changes rarely. |
| `current.md` | Dated log: what you're in the middle of and where you stopped. Newest first. |
| `queue.md` | Open loops: Now (max 3), Next, Inbox, Waiting on, Someday. |
| `areas/` | One folder per life area (health, money, work…) with its goals and notes. |
| `archive/` | Old plans and finished projects. Kept, never a source of truth. |
| `.opencode/commands/` | Thin wrappers so the same `/` commands work in OpenCode. |
| `life` | Tiny launcher: `./life start` (session start), `./life status`, `./life add "thing"`, `./life archive`, `./life check`. |
| `examples/sam/` | A filled-in example so you can see what "set up" looks like. |

### Commands and skills

| Type it | What happens |
|---|---|
| `/life-architect` | The setup interview. Run again any time to re-tune. |
| `/start-day` | Picks today's 1–3 things from your queue and names the first 2-minute step. |
| `/eod` | End of day: records where you stopped, sweeps loose ends into the queue. |
| `/weekly-review` | 20 minutes: clear the inbox, check areas, pick next week's focus. |
| `/unstuck` | For when you're frozen. Shrinks the next step until you can start. |
| `/grill-me` | Relentless interview to settle a decision or plan before you act. |
| `/i-have-adhd` | Shapes every reply for an ADHD brain. Setup can make it always-on. |
| `/lavish` | Optional: turns a plan or review into a visual page you can annotate. |

## Where this came from

| In the software workflow | In Life OS |
|---|---|
| Workspace contract (`AGENTS.md`) | How the agent treats you |
| Workspace map (`context.md`) | Life map |
| Session log (`current.md`) | Where you stopped |
| Task tracker (`linear.md`) | `queue.md`, or a pointer to Todoist/Notion/etc. |
| Launcher `sync` / `status` | `./life start` at session start |
| Grill before building a feature | Grill before a big life decision |
| `/eod` | `/eod` shutdown ritual |
| Never touch prod config without approval | Never send, book, buy, or delete without your OK |

## Sharing with friends

Share the **template** repo, never your filled-in one. Each person clones the
template and runs `/life-architect`; the agent explains the benefits and builds
their own version. Nothing of yours travels with it.

## Privacy

Your filled-in repo holds health, money and relationship details. Keep it
private. Put anything you'd never want on a server in `private/` (git-ignored).

## Not therapy

This is an organising tool. It does not diagnose anything and it is not a
substitute for a doctor, therapist or coach. If you're in crisis, contact local
emergency services or a crisis line (US: call or text 988).

## License

MIT. Vendored skills keep their own MIT credits; see `NOTICE.md`.
