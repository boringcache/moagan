#!/usr/bin/env bash
set -euo pipefail
export MOAGAN_NON_INTERACTIVE=1
export MOAGAN_HOME="$GITHUB_WORKSPACE/source/.moagan-home"
mkdir -p "$RUNNER_TEMP/validation"
git rev-parse HEAD > "$RUNNER_TEMP/validation/source.txt"
case "$VALIDATION_CHECK" in
  clippy) cargo clippy --locked --all-targets -- -D warnings ;;
  test-tests) cargo test --locked --tests --no-fail-fast ;;
  test-lib) cargo test --locked --lib --bins --no-fail-fast ;;
  test-doc) cargo test --locked --doc ;;
  smoke|e2e) cargo build --locked; make "$VALIDATION_CHECK" ;;
  *) echo "Unknown validation check: $VALIDATION_CHECK" >&2; exit 1 ;;
esac
