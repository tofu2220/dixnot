#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 [--expect <agent-role>]" >&2
  exit 64
}

expected_agent="commit"

case "$#" in
  0) ;;
  2)
    [[ "$1" == "--expect" ]] || usage
    expected_agent="$2"
    ;;
  *) usage ;;
esac

if [[ ! "$expected_agent" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Invalid agent role: $expected_agent" >&2
  exit 64
fi

repo_root="$(git rev-parse --show-toplevel)"
codex_root="${CODEX_HOME:-"$HOME/.codex"}"

session_dirs=()
for dir in "$codex_root/sessions" "$codex_root/archived_sessions"; do
  [[ -d "$dir" ]] && session_dirs+=("$dir")
done

if [[ "${#session_dirs[@]}" -eq 0 ]]; then
  echo "No local Codex session directories found in: $codex_root" >&2
  exit 1
fi

mapfile -d '' -t session_files < <(
  find "${session_dirs[@]}" -type f -name '*.jsonl' -print0
)

if [[ "${#session_files[@]}" -eq 0 ]]; then
  echo "No local Codex session files found." >&2
  exit 1
fi

REPO_ROOT="$repo_root" EXPECTED_AGENT="$expected_agent" \
  perl -MJSON::PP - "${session_files[@]}" <<'PERL'
use strict;
use warnings;

my $repo_root = $ENV{REPO_ROOT};
my $expected  = $ENV{EXPECTED_AGENT};
my $json      = JSON::PP->new->utf8;

sub same_directory {
    my ($left, $right) = @_;
    return 0 unless defined $left;

    $left =~ s{^file://}{};
    $left =~ s{/$}{};
    $right =~ s{/$}{};

    return $left eq $right;
}

my @sessions;

for my $file (@ARGV) {
    open my $fh, '<', $file or next;

    my ($cwd, $session_id, $latest_at);
    my @agents;

    while (my $line = <$fh>) {
        my $record = eval { $json->decode($line) };
        next if !$record || ref $record ne 'HASH';

        my $timestamp = $record->{timestamp};
        if (defined $timestamp && (!defined $latest_at || $timestamp gt $latest_at)) {
            $latest_at = $timestamp;
        }

        my $payload = $record->{payload};
        next unless ref $payload eq 'HASH';

        if (($record->{type} // '') eq 'session_meta') {
            $cwd        //= $payload->{cwd};
            $session_id //= $payload->{session_id} // $payload->{id};
        }

        my $item = $payload->{item};
        next unless ref $item eq 'HASH';

        my $receivers = $item->{receiver_agents};
        next unless ref $receivers eq 'ARRAY';

        my $model = $item->{model} // 'unknown';

        for my $receiver (@$receivers) {
            next unless ref $receiver eq 'HASH';

            push @agents, {
                role     => $receiver->{agent_role} // 'unknown',
                nickname => $receiver->{agent_nickname} // '-',
                model    => $model,
            };
        }
    }

    next unless same_directory($cwd, $repo_root);

    push @sessions, {
        id      => $session_id // 'unknown',
        updated => $latest_at // '',
        agents  => \@agents,
    };
}

if (!@sessions) {
    print "Result: NOT FOUND\n";
    print "No Codex session belongs to this repository.\n";
    exit 1;
}

@sessions = sort { $b->{updated} cmp $a->{updated} } @sessions;
my $session = $sessions[0];

my %seen;
my @agents = grep {
    my $key = join "\0", $_->{role}, $_->{nickname}, $_->{model};
    !$seen{$key}++;
} @{ $session->{agents} };

my $short_id = substr($session->{id}, 0, 8);

print "Latest session: $short_id";
print " ($session->{updated})" if $session->{updated};
print "\n\n";

if (!@agents) {
    print "No spawned subagents were recorded in this session.\n";
    print "Result: NOT FOUND\n";
    exit 1;
}

printf "%-16s %-16s %s\n", "Agent", "Nickname", "Model";
printf "%-16s %-16s %s\n", "-" x 16, "-" x 16, "-" x 20;

for my $agent (@agents) {
    printf "%-16s %-16s %s\n",
        $agent->{role},
        $agent->{nickname},
        $agent->{model};
}

my @matches = grep { $_->{role} eq $expected } @agents;

if (!@matches) {
    print "\nExpected agent: $expected\n";
    print "Result: NOT FOUND\n";
    exit 1;
}

my $config_file = "$repo_root/.codex/agents/$expected.toml";
my $expected_model;

if (open my $config, '<', $config_file) {
    while (my $line = <$config>) {
        if ($line =~ /^\s*model\s*=\s*"([^"]+)"/) {
            $expected_model = $1;
            last;
        }
    }
    close $config;
}

if (!defined $expected_model) {
    print "\nExpected agent: $expected\n";
    print "Result: FOUND (model is inherited or not configured explicitly)\n";
    exit 0;
}

my @wrong_models = grep { $_->{model} ne $expected_model } @matches;

print "\nExpected agent: $expected ($expected_model)\n";

if (@wrong_models) {
    print "Result: MISMATCH\n";
    exit 1;
}

print "Result: MATCH\n";
PERL
