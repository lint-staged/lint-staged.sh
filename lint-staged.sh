#!/usr/bin/env sh

DIM='\033[1;30m'
NC='\033[0m'

get_staged_files() {
    git diff --staged --name-only --diff-filter ACMR -z -- "$@" | xargs --null
}

usage() {
    echo "lint-staged.sh" - run linters against Git staged files
    echo ""
    echo "${DIM}Usage:${NC}   lint-staged.sh \"<command>\" \"<glob>\" [\"<glob>\"]..."
    echo "${DIM}Example:${NC} lint-staged.sh \"echo staged files:\" \"*\""
    echo ""
    echo "${DIM}At least one glob is required. They are passed"
    echo "${DIM}directly to the \"git diff\" command."
}

lint_staged() {
    if [ $# -lt 2 ]; then
        usage
        exit 2
    fi

    local command="$1"
    shift # remove first argument

    local files=$(get_staged_files "$@")
    if [ -n "$files" ]; then
        echo "${DIM}${command} $files${NC}"
        eval "$command" "$files"
        echo ""
    fi

    exit 0
}

lint_staged "$@"
