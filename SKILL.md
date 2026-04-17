---
name: lint-staged
description: Lint staged files, optionally filtering them with globs, in a git repo. Run commands or scripts with the filtered list of staged files as arguments. Can also just list the staged files, optionally filtered. Useful for checking the current work and whether the upcoming commit is clean, linted and formatted.
compatibility: Requires Bourne shell (sh), git and xargs
---

# Lint Staged

Run a specified command against files that are staged in a Git repo (typically the current workspace). The staged files are filtered by one or more globs using the Git glob syntax.

## Examples

- lint staged files
- run prettier on staged Markdown files
- lint staged test files
- which JS files are staged?
- what linters should I run on the currently staged files?
- check my current work
- is my commit good?

## Step 1: Generate globs

The user wants to run commands against specific staged files and may have asked to filter them. Use the syntax of the UNIX "fnmatch" tool: a single asterisk `*` does will not match a `/` in the file's pathname, but two `**` will.

| Example query           | example glob    |
| ----------------------- | --------------- |
| All JS files            | `*.js`          |
| All test files          | `*.test.ts`     |
| Markdown and JSON files | `*.md` `*.json` |

You should consider the contents of the current workspace to generate useful globs.

If the user wants to lint all staged files, you don't need to use any glob.

## Step 2: List staged files by running Git

After generating the globls, you should directly list the files by running a Git command using the `Bash` tool:

```shell
git diff --staged --name-only --diff-filter ACMR -z -- "$@" | xargs -0 git rev-parse --sq-quote
```

where `$@` is the list of globs matching the staged files the user wants to run the command against.

If the command fails with the output `warning: Not a git repository`, the current workspace is not a Git directory and using this skill doesn't make sense. Otherwise, the result is a string of staged files that are wrapped in sigle quotes separated by a space.

### Examples

- the user wants to run against all JS files, you should run:
  ```shell
  git diff --staged --name-only --diff-filter ACMR -z -- "*.js" | xargs -0 git rev-parse --sq-quote
  ```
- the user wants to run against all markdown and JSON files, you should run:
  ```shell
  git diff --staged --name-only --diff-filter ACMR -z -- "*.md" "*.json" | xargs -0 git rev-parse --sq-quote
  ```
- the user wants to run against **all** staged files, you should run:
  ```shell
  git diff --staged --name-only --diff-filter ACMR -z | xargs -0 git rev-parse --sq-quote
  ```

## Step 3: Run the command

If the user wants run a specific command like `prettier` or `eslint`, try to do it. If the current workspace is using some kind of a package manager, the command might need to be invoked with it, for example `npx prettier` or `make fmt`. Otherwise the command should be available globally. The command might also be a script file available locally, like `./linter.sh`

If the command is generic like "_lint_", it may be possible to find if by checking a manifest file, like the `package.json` for lint tools, and use those. Otherwise the user needs to be more specific.

## Optional and final step 4: update the index

If the user asks, or if the command updated the staged files, they might want to update the git index with the changes. This can be done by running:

```shell
git update-index --again
```
