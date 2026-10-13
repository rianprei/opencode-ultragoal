# Changelog

## v1.2 (2026-10-13)

### Added
- `budget turns 40 | tempo 4h | tokens 300k` verb: re-mounts contract line 5, reactivates budget_exceeded goals
- `.ultraplan/state.md` state file with terminal markers (`Estado: active|paused|blocked|complete`) + timestamps
- Item 3 (Constraints) checked EVERY TURN alongside item 2 (Verification) — COMPLETE requires both green
- `goalmax_pause`/`goalmax_resume` mapped for every PAUSED state (engine integration)
- `goalmax_budget` mapped for budget verb (engine reactivates from budget_exceeded)
- `goalmax_blocked` mapped for clear/stop (no zombie goals re-injecting)
- goalmax_set re-registration on `update` (with accumulated consumption noted first)
- Audit parameters (auditEnabled/auditModel/auditInterval) passed when defined
- Precedence rule: verbs (status/pause/resume/clear/budget/update) matched before condition parsing
- Destructive-action policy from Claude Code 2.1.296 binary strings
- Network consent: first use of each category requires explicit written OK
- Token honesty: "estimado" label (engine uses heuristic, not real API tokens)
- State reconciliation rule: with engine, motor state is authoritative; state.md is ledger/mirror

### Fixed
- `bash/sh/zsh` removed from goalmax engine verify allowlist (shell-escape closed)
- `echo ok` fake-exit-0 patch removed from engine
- `goalmax_complete` now enforces exitCode === 0 (was checking only lastVerification existence)
- Idle handler re-hydrates from disk (was memory-only, goals died on restart)
- Migration v1→v2 now creates `.v1.backup.json` as documented
- Dead `stagnation` branch removed
- `webfetch`/`websearch` set to "ask" in autopilot permission (mechanical enforcement of "rede: nunca")
- `§3` collision resolved: contract items referenced as "item 2 (Verificação)" / "item 3 (Constraints)"
- BLOCKED state has defined exit: `update <novo>` (new incarnation) or `clear`
- Table row for "item 2 exit 0 but item 3 red" → continues, persiste 2 turnos → PAUSED

## v1.0 (2026-10-12)

- Initial release
- Built from Codex CLI (open source), Claude Code 2.1.296 binary strings, Grok Build, goalmax v2
