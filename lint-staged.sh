#!/usr/bin/env sh

set -e

# If FORCE_COLOR is set, or stdout is a terminal and NO_COLOR is not set,
# then use ANSI codes for dimmed text in the output,
# else just output plain text.
#
# See https://force-color.org and https://no-color.org
#
if [ -n "${FORCE_COLOR:-}" ] || { [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; }; then                                                                                                   
    DIM='\033[1;30m'                                                                                                                                                              
    NC='\033[0m'                                                                                                                                                                  
else                                                                                                                                                                            
    DIM=''                                                                                                                                                                        
    NC=''                                                                                                                                                                         
fi 

get_staged_files() {
    git diff --staged --name-only --diff-filter ACMR -z -- "$@" | xargs -0 git rev-parse --sq-quote
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
        echo "${DIM}$command$files${NC}"
        eval "$command$files"
        echo ""
    fi

    exit 0
}

lint_staged "$@"
