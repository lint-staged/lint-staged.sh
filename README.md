# `lint-staged.sh`

> Run linters against Git staged files

`lint-staged.sh` is a shell script to evaluate a command with the list of [Git](https://git-scm.com) staged files as its arguments, filtered by globs. There are no additional features.

> [!TIP]
> If you use [lint-staged](https://github.com/lint-staged/lint-staged) to check if staged files are valid — _but not automatically fix them_ — you might be interested in this simpler shell script.

## Example

Run `prettier --check` with all staged JS, JSON and MD files as its arguments:

```shell
lint-staged.sh "prettier --check" "*.js" "*.json" "*.md"
```

Given staged files `index.js` and `README.md`, this will essentially run:

```shell
prettier --check index.js README.md
```

## Installation

Copy the [`lint-staged.sh`](./lint-staged.sh) file from this repo somewhere and run it. It should work in the [Bourne shell (`sh`)](https://en.wikipedia.org/wiki/Bourne_shell).

You probably want to run `lint-staged.sh` in a Git `pre-commit` hook so that you can abort the commit if one of your commands fails.

For example, create the file `.git/hooks/pre-commit` (and make it executable):

```shell
#!/bin/sh
lint-staged.sh "prettier --check" "*.js" "*.json" "*.md"
```

If you are using [`npm`](https://www.npmjs.com), you can install `lint-staged.sh` and [Husky](https://github.com/typicode/husky) from there:

```shell
npm install --save-dev lint-staged.sh husky
npx husky init

# Adjust this file according to your needs
edit .husky/pre-commit
```
