#!/usr/bin/env bash

# --- begin runfiles.bash initialization v3 ---
# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; set +e; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v3 ---


set -euo pipefail

# MARK - Functions

fail() {
  echo >&2 "$@"
  exit 1
}

# MARK - Args

if [[ "$#" -lt 1 ]]; then
  fail "Usage: $0 /path/to/bin <args>"
fi
RUSTFMT="$(rlocation "$1")"

# MARK - Test

# simulate bazel run with setting BUILD_WORKING_DIRECTORY
export BUILD_WORKING_DIRECTORY="$PWD" 

OUTPUT="$(echo -e "fn main() {\n\n}" | "$RUSTFMT")"

# without newlines in body
EXPECTED_OUTPUT="fn main() {}"
[[ "${OUTPUT}" == "${EXPECTED_OUTPUT}" ]] ||
  fail 'Expected "'"${EXPECTED_OUTPUT}"'", but was' "${OUTPUT}"