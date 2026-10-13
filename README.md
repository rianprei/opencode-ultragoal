# opencode-ultragoal

> **Autonomous goal loop with a hard contract** — the synthesis of the industry `/goal` pattern: Codex's protocol + Claude Code's error taxonomy + Grok's visible checklist + goalmax's exit-code verification. Every finding independently verified. Every turn visible. Every pause has a reason. 100% local. No cloud. No quota. No limits.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.2-green.svg)](CHANGELOG.md)
[![Runtimes](https://img.shields.io/badge/runtimes-opencode%20%7C%20claude%20%7C%20codex%20%7C%20grok-blueviolet.svg)](#installation)
[![Cloud Free](https://img.shields.io/badge/cloud-free-brightgreen.svg)](#what-it-solves)
[![Quota Free](https://img.shields.io/badge/quota-unlimited-brightgreen.svg)](#what-it-solves)

## What it solves

The `/goal` pattern is now industry infrastructure — but every implementation has holes:

| Implementation | The hole |
|---|---|
| **Claude Code `/goal`** | Evaluator reads transcript only (fooled by "Goal Achieved" while work is pending — issue #58516). No token/turn budget (burned 80% of a weekly quota in 11 hours — issue #58450). Goal can't be stopped when human input is needed (5 open issues, Oct 2026). |
| **Codex `/goal`** | Closest to right — but token budget is optional and the goal dies on restart. |
| **Grok `/goal`** | Tier-gated at $300/month. |

This replica closes every hole with a **6-component contract** that starts before the first turn of work:

```
🎯 ULTRAGOAL — <condition>
1. Outcome:     measurable end state (command result, file, queue empty)
2. Verificação: exact command + what proves it ("pytest X exits 0")
3. Constraints: what can't regress ("no other test breaks")
4. Boundaries:  Allow: <paths> · Deny: <paths>
5. Budgets:     turns 20 · time 2h · tokens ~150k
6. Stop:        same blocker 2 turns · verification won't run
```

## The machine

```
┌─────────────────────────────────────────────────────────────┐
│              /ultragoal <condition>                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─── CONTRATO ──┐  Show contract AND start working         │
│  │ 6 components  │  in the SAME turn — no waiting           │
│  └──────┬─────────┘  Goal never waits for confirmation      │
│         ▼                                                    │
│  ┌─── LOOP ──────┐  Each turn:                               │
│  │ Continue       │  1. Work toward objective               │
│  │ objective      │  2. Checkpoint: PROGRESSO|ESPERA|NONE   │
│  │                │     → write to .ultragoal/state.md     │
│  │                │  3. Verify: item 2 (exit 0)            │
│  │                │     AND item 3 (constraints)            │
│  │                │  4. State machine ↓                      │
│  └──────┬─────────┘                                         │
│         ▼                                                    │
│  ┌─── ESTADOS ───┐                                           │
│  │                │  COMPLETE: exit 0 + constraints green    │
│  │                │  PAUSED·blocker: same blocker 2 turns   │
│  │                │  PAUSED·precisa de humano: asks YOU     │
│  │                │  PAUSED·sem progresso: 3 turns spinning  │
│  │                │  PAUSED·budget: budget hit → wrap up    │
│  │                │  BLOCKED: dead end + what YOU can do    │
│  │                │                                           │
│  │  Exits:        │  budget turns 40 · update <novo> · clear │
│  └────────────────┘                                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## What makes this different

| Feature | Claude Code `/goal` | Codex `/goal` | **This** |
|---|---|---|---|
| Verification | Model reads transcript | "true and verified" in template | **Command exit 0 + constraints checked** |
| Budget | Text clause ("or stop after 20 turns") | Protocol field (optional) | **Hard in contract, enforced per turn** |
| Constraints | Not checked | Implied in objective | **Checked every turn alongside verification** |
| Boundaries | None | None | **Allow/Deny paths** |
| Can't stop | 5 open issues (Oct 2026) | — | **PAUSED·precisa de humano — never re-prompts** |
| State persistence | In-memory (lost on restart) | SQL (but idle handler reads memory) | **`.ultragoal/state.md` + engine state** |
| Progress check | None | Template mention | **PROGRESSO/ESPERA VERIFICADA/SEM PROGRESSO per turn** |
| Anti-goal-hacking | None | None | **"Never redefine success to a smaller task"** + destructive-action policy |
| Auditor | None | Optional (default ON) | **goalmax audit (claude-haiku, every 3 milestones)** |
| Cost | Usage credits | API cost | **Local tokens only** |

## The destructive-action policy

From the actual Claude Code 2.1.296 binary:

> A destructive step is not user-requested just because it's one way to accomplish the goal. "Clean up the repo" does not authorize `git clean -fdx`. "Get the deploy working" does not authorize a rollback migration.
>
> **Scope escalation = autonomous behavior → stop and ask.**

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/rianprei/opencode-ultragoal/main/install.sh | bash
```

### Manual

| Runtime | File | Destination |
|---|---|---|
| **opencode** | `src/opencode/ultragoal.md` | `~/.config/opencode/commands/ultragoal.md` |
| **Claude Code** | `src/claude/ultragoal.md` | `~/.claude/commands/ultragoal.md` |
| **Codex** | `src/codex/SKILL.md` | `~/.codex/skills/ultragoal/SKILL.md` |
| **Grok Build** | `src/grok/SKILL.md` | `~/.grok/skills/ultragoal/SKILL.md` |

## Usage

```
/ultragoal all tests in test/auth pass and lint is clean
/ultragoal                                    # status
/ultragoal budget turns 40                    # extend budget
/ultragoal update migrate to JWT instead      # re-steer, keep progress
/ultragoal clear                              # stop and report
```

## goalmax engine integration (opencode + Claude Code)

If the `goalmax` engine plugin is loaded (tools `goalmax_*`), ultragoal registers the contract via `goalmax_set`, verifies via `goalmax_verify` (allowlist-enforced, no shell), completes via `goalmax_complete` (which **refuses exit code ≠ 0**), pauses via `goalmax_pause`, and the engine auto-continues between turns.

## The state file

`.ultragoal/state.md` persists:

```
Estado: active · iniciado_em: 2026-10-13T10:00:00Z · ultima_atividade: 2026-10-13T10:34:00Z

Turno 3: PROGRESSO — fixed off-by-one in total_do_carrinho (vendas.py:19)
Turno 4: PROGRESSO — added fidelidade table + 8 tests
Turno 5: ESPERA VERIFICADA — pytest running (pid 12345, confirmed alive)
```

This survives restart and context compaction. Without it, the breakers lose their counters and the state machine goes blind.

## Provenance

- **Codex CLI** (open source): ThreadGoal protocol, continuation/budget_limit/objective_updated templates, no-progress classification
- **Claude Code 2.1.296**: 8 pause-state strings extracted from the binary, destructive-action policy, error taxonomy, check-in backoff
- **Grok Build**: status/pause/resume/clear verbs, visible progress checklist
- **goalmax v2**: 6-component contract, exit-code-0 verification, boundaries allow/deny, independent auditor

## License

MIT — see [LICENSE](LICENSE)
