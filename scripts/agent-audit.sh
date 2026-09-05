#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SESSIONS_DIR="$CODEX_HOME/sessions"

LIMIT=30
SHOW_ALL=0
WATCH=0
JSON=0

usage() {
  cat <<'EOF'
Usage: ./scripts/codex-agents.sh [options]

Show effective model/reasoning for recent Codex agent threads by reading
persisted rollout JSONL files.

Options:
  -n, --limit N   Inspect the N most recently modified rollout files (default: 30)
  -a, --all       Include root/non-agent threads
  -w, --watch     Refresh every 2 seconds
      --json      Emit JSON lines instead of a table
  -h, --help      Show this help

Environment:
  CODEX_HOME      Codex home directory (default: ~/.codex)

Examples:
  ./scripts/codex-agents.sh
  ./scripts/codex-agents.sh -n 100
  ./scripts/codex-agents.sh --all
  ./scripts/codex-agents.sh --watch
EOF
}

die() {
  printf 'codex-agents: %s\n' "$*" >&2
  exit 1
}

need() {
  command -v "$1" >/dev/null 2>&1 || die "missing dependency: $1"
}

while (($#)); do
  case "$1" in
    -n|--limit)
      (($# >= 2)) || die "$1 requires a number"
      LIMIT="$2"
      [[ "$LIMIT" =~ ^[1-9][0-9]*$ ]] || die "limit must be a positive integer"
      shift 2
      ;;
    -a|--all)
      SHOW_ALL=1
      shift
      ;;
    -w|--watch)
      WATCH=1
      shift
      ;;
    --json)
      JSON=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1 (try --help)"
      ;;
  esac
done

need jq
need find
need sort
need head

[[ -d "$SESSIONS_DIR" ]] || die "sessions directory not found: $SESSIONS_DIR"

recent_files() {
  # GNU/BSD-portable enough for typical Codex environments:
  # stat gives epoch mtime; fallback to ls -t if neither flavor is available.
  local f
  while IFS= read -r -d '' f; do
    if stat -c '%Y' "$f" >/dev/null 2>&1; then
      printf '%s\t%s\n' "$(stat -c '%Y' "$f")" "$f"
    elif stat -f '%m' "$f" >/dev/null 2>&1; then
      printf '%s\t%s\n' "$(stat -f '%m' "$f")" "$f"
    else
      printf '0\t%s\n' "$f"
    fi
  done < <(find "$SESSIONS_DIR" -type f -name 'rollout-*.jsonl' -print0 2>/dev/null) \
    | sort -rn -k1,1 \
    | head -n "$LIMIT" \
    | cut -f2-
}

inspect_file() {
  local file="$1"

  jq -c -s --arg file "$file" '
    def first_meta:
      (
        map(select(.type == "session_meta")) | first
      ) // {};

    def last_turn:
      (
        map(select(.type == "turn_context")) | last
      ) // {};

    (first_meta) as $metaLine
    | (last_turn) as $turnLine
    | ($metaLine.payload // {}) as $p
    | ($turnLine.payload // {}) as $t

    | {
        file: $file,
        timestamp: (
          $turnLine.timestamp
          // $metaLine.timestamp
          // $p.timestamp
          // null
        ),
        thread: (
          $p.id
          // $p.thread_id
          // $p.session_id
          // $p.meta.id
          // $p.meta.thread_id
          // $p.meta.session_id
          // null
        ),
        parent: (
          $p.parent_thread_id
          // $p.meta.parent_thread_id
          // null
        ),
        agent: (
          $p.agent_path
          // $p.meta.agent_path
          // null
        ),
        nickname: (
          $p.agent_nickname
          // $p.meta.agent_nickname
          // null
        ),
        role: (
          $p.agent_role
          // $p.meta.agent_role
          // null
        ),
        model: (
          $t.model
          // $t.collaboration_mode.settings.model
          // $t.collaboration_mode.model
          // null
        ),
        effort: (
          $t.effort
          // $t.reasoning_effort
          // $t.collaboration_mode.settings.reasoning_effort
          // $t.collaboration_mode.reasoning_effort
          // null
        ),
        cwd: (
          $t.cwd
          // $p.cwd
          // $p.meta.cwd
          // null
        )
      }
  ' "$file" 2>/dev/null || true
}

collect() {
  local file row
  while IFS= read -r file; do
    [[ -n "$file" ]] || continue
    row="$(inspect_file "$file")"
    [[ -n "$row" ]] || continue

    if (( SHOW_ALL == 0 )); then
      jq -e '.agent != null and .agent != ""' <<<"$row" >/dev/null 2>&1 || continue
    fi

    printf '%s\n' "$row"
  done < <(recent_files)
}

render_json() {
  collect
}

render_table() {
  local rows
  rows="$(collect)"

  if [[ -z "$rows" ]]; then
    if (( SHOW_ALL == 0 )); then
      echo "No recent subagent rollouts found."
      echo "Try: $0 --all -n 100"
    else
      echo "No recent Codex rollouts found."
    fi
    return
  fi

  {
    printf 'AGENT\tTHREAD\tMODEL\tEFFORT\tUPDATED\tCWD\n'
    jq -r '
      [
        (.agent // "/root"),
        ((.thread // "?") | if length > 13 then .[0:13] + "…" else . end),
        (.model // "?"),
        (.effort // "?"),
        (
          (.timestamp // "?")
          | if . == "?" then .
            else sub("\\.[0-9]+Z$"; "Z")
          end
        ),
        (.cwd // "?")
      ] | @tsv
    ' <<<"$rows"
  } | {
    if command -v column >/dev/null 2>&1; then
      column -t -s $'\t'
    else
      cat
    fi
  }
}

run_once() {
  if (( JSON == 1 )); then
    render_json
  else
    render_table
  fi
}

if (( WATCH == 1 )); then
  while true; do
    if [[ -t 1 ]]; then
      printf '\033[2J\033[H'
    fi
    printf 'Codex agents — %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')"
    run_once
    sleep 2
  done
else
  run_once
fi
