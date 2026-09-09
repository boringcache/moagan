#!/usr/bin/env bash
set -euo pipefail
export MOAGAN_HOME="$GITHUB_WORKSPACE/source/.moagan-home"
mkdir -p "$RUNNER_TEMP/validation"
git rev-parse HEAD > "$RUNNER_TEMP/validation/source.txt"
compiler=(cargo)
if [[ "$VALIDATION_PROVIDER" == BoringCache ]]; then
  compiler=(boringcache cargo "--$VALIDATION_POLICY")
fi
case "$VALIDATION_CHECK" in
  clippy) "${compiler[@]}" clippy --locked --all-targets -- -D warnings ;;
  test-tests) MOAGAN_NON_INTERACTIVE=1 "${compiler[@]}" test --locked --tests --no-fail-fast ;;
  test-lib) MOAGAN_NON_INTERACTIVE=1 "${compiler[@]}" test --locked --lib --bins --no-fail-fast ;;
  test-doc) MOAGAN_NON_INTERACTIVE=1 "${compiler[@]}" test --locked --doc ;;
  smoke|e2e) "${compiler[@]}" build --locked; make "$VALIDATION_CHECK" ;;
  *) echo "Unknown validation check: $VALIDATION_CHECK" >&2; exit 1 ;;
esac
