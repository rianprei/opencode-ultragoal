# Changelog

## v1.2 (2026-10-13)

### Added
- `budget turns 40 | tempo 4h | tokens 300k` verb: re-mounts contract line 5
- Item 3 (Constraints) checked EVERY TURN alongside item 2 (Verification) — COMPLETE requires both green
- `.ultragoal/state.md` state file with terminal markers (`Estado: active|paused|blocked|complete`) + timestamps (`iniciado_em`, `ultima_atividade`)
- Precedence rule: verbs (status/pause/resume/clear/budget/update) matched before condition parsing
- Destructive-action policy from Claude Code 2.1.296 binary strings
- Network consent: first use of each category requires explicit written OK
- Token honesty: "estimado" label (heuristic, not real API tokens)
- State reconciliation: with engine, motor state is authoritative; state.md is ledger/mirror
- Table row for "item 2 exit 0 but item 3 red" → continues, persists 2 turnos → PAUSED
- `§3` collision resolved: contract items referenced as "item 2 (Verificação)" / "item 3 (Constraints)"
- BLOCKED state has defined exit: `update <novo>` or `clear`

### Changed
- Goalmax engine integration (separate plugin, not shipped in this repo): `goalmax_pause`/`goalmax_resume` mapped for PAUSED states; `goalmax_budget` for budget verb; `goalmax_complete` enforces exitCode === 0. These are engine-level fixes — see the goalmax plugin changelog for details.

## v1.1 (2026-10-13)

### Added
- Constraints checked every turn alongside verification
- `.ultragoal/state.md` with terminal markers
- `goalmax_pause`/`goalmax_resume` mapped for every PAUSED state
- `budget` verb for re-mounting contract line 5
- Guard for "goal already active" on new invocation
- Network consent: first use of each category requires written OK

## v1.0 (2026-10-12)

- Initial release
- Built from Codex CLI (open source), Claude Code 2.1.296 binary strings, Grok Build, goalmax v2
