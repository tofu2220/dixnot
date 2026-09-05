# Codex Agent Inspector

`codex-agents.sh` shows the effective model and reasoning effort used by recent Codex agent threads. It reads persisted rollout JSONL files from your Codex sessions directory.

## Requirements

* `jq` must be installed.
* Codex session data must exist under `$CODEX_HOME/sessions`.
* `CODEX_HOME` defaults to `~/.codex`.
* `column` is optional; when unavailable, the script falls back to plain tab-separated output.

If your Codex home directory is elsewhere, set `CODEX_HOME` when running the script:

```bash
CODEX_HOME=/path/to/.codex ./scripts/codex-agents.sh
```

## Usage

Run from the repository root:

```bash
./scripts/codex-agents.sh
```

By default, the script inspects the 30 most recently modified rollout files and shows subagent threads only.

### Inspect more rollout files

```bash
./scripts/codex-agents.sh -n 100
```

### Include root threads

```bash
./scripts/codex-agents.sh --all
```

You can combine options:

```bash
./scripts/codex-agents.sh --all -n 100
```

### Refresh every two seconds

```bash
./scripts/codex-agents.sh --watch
```

This is useful when you want to watch agent threads appear while Codex is running.

### Emit JSON Lines

Use JSON output when you want to pipe the results into another tool:

```bash
./scripts/codex-agents.sh --json
```

For example:

```bash
./scripts/codex-agents.sh --json | jq .
```

## Options

| Option          | Description                                           |
| --------------- | ----------------------------------------------------- |
| `-n, --limit N` | Inspect the `N` most recently modified rollout files. |
| `-a, --all`     | Include root threads as well as subagent threads.     |
| `-w, --watch`   | Refresh the output every two seconds.                 |
| `--json`        | Emit JSON Lines instead of a table.                   |
| `-h, --help`    | Show built-in help.                                   |

## Verification

To verify that this guide stays aligned with the script:

```bash
./scripts/codex-agents.sh --help
```
