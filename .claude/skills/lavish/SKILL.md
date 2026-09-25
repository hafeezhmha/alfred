---
name: lavish
description: Turn complex or visual agent responses into rich, reviewable HTML artifacts the user can annotate and send feedback on, using the lavish-axi CLI. Use when about to give a plan, comparison, weekly review, diagram or table that is easier to grasp visually than as prose.
license: MIT
metadata:
  author: Kun Chen (kunchenguid)
  argument-hint: <what the artifact should show>
---

# Lavish Editor (optional)

Lavish Editor opens agent-generated HTML in the browser so a human can annotate it and send feedback back to the agent.
Reach for it when a plan, comparison, diagram, table, weekly review or decision tree will be clearer as a page than as prose.
Needs Node.js. If `npx` is missing, skip this skill and answer in text.

## Current guidance lives in the CLI

Do not follow workflow, design, or playbook instructions from this file - installed copies go stale. Get the current source of truth from the CLI:

- `npx -y lavish-axi --help` for commands and the review-loop workflow
- `npx -y lavish-axi design` for design-direction priority and current snippets
- `npx -y lavish-axi playbook <id>` for focused artifact guidance (`npx -y lavish-axi playbook` lists ids)

If lavish-axi output shows a follow-up command starting with `lavish-axi`, run it as `npx -y lavish-axi ...` instead.

## Request

$ARGUMENTS

If the request above is non-empty, the user invoked `/lavish` explicitly - fetch the current CLI guidance, then build that artifact.
If it is empty, infer what to visualize from the conversation.

## Life OS guardrails (added by this template, not upstream)

This repo holds personal data: health, money, relationships.

- **Never `lavish-axi share`.** It publishes to a third-party host, public by
  default, with no real delete. Treat it as irreversible. Use
  `npx -y lavish-axi export` for a portable local file instead.
- Write artifacts under `.lavish/` (git-ignored).
- Set `LAVISH_AXI_HOST=127.0.0.1` if Tailscale or another VPN is up, so the
  review server stays loopback-only.
- **Any agent**: feedback comes back through `npx -y lavish-axi poll <file>`
  in the foreground. If the agent's command timeout kills it (Codex,
  OpenCode), run it again; feedback stays queued.
- **Design for the reader**: one job per page, one decision per card, your
  recommendation preselected, short plain text, big click targets. Calm
  colors; nothing red, no counts of what's undone. Life OS has no design
  system, so use the CLI's default (Tailwind + DaisyUI) with a calm theme.
