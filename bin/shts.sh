#!/usr/bin/env bash
# shellcheck disable=SC2155,SC2046

#
# Helper Functions and Additional Tests Variables and Functions when running bats tests $BATS_ROOT

: "${BASH_SOURCE?}"

# <html><h2>Saved $PATH on First Suite Test Start</h2>
# <p><strong><code>$SHTS_PATH</code></strong></p>
# </html>
export SHTS_PATH="${PATH}"

# <html><h2>Git Top Path</h2>
# <p><strong><code>$SHTS_TOP</code></strong> contains the git top directory using $PWD.</p>
# </html>
export SHTS_TOP="$(git rev-parse --show-toplevel 2>/dev/null || true)"

__brew_lib="$(brew --prefix)/lib"

#######################################
# private function to list all functions exported to be used in shts.ss and shts
# Globals:
#   SHTS_ARRAY
#   BATS_TEST_DESCRIPTION
#######################################
__shts_functions() {
  file_functions "${__brew_lib}"/*/src/*.bash
  file_functions "${BASH_SOURCE[0]}"
  awk -F '(' "/^  $(basename "${BASH_SOURCE[0]}" .sh)::.*\(\)/ { gsub(/ /,\"\",\$1); print \$1 }" "${BASH_SOURCE[0]}"
}

#######################################
# Restores $PATH to $SHTS_PATH and sources .envrc.
# Globals:
#   PATH
# Arguments:
#  None
#######################################
envrc() {
  if [ "${SHTS_TOP-}" ]; then
    PATH="${SHTS_PATH}"
    if test -f "${SHTS_TOP}/.envrc"; then
      . "${SHTS_TOP}/.envrc" || return
    else
      >&2 echo "${BASH_SOURCE[0]##*/}: ${SHTS_TOP}/.envrc: No such file"
      return 1
    fi
  else
    >&2 echo "${BASH_SOURCE[0]##*/}: ${PWD}: not a git repository (or any of the parent directories)"
    return 1
  fi
}

#######################################
# get functions in file/files
# Arguments:
#  None
#######################################
file_functions() { awk -F '(' '/^[a-z].*\(\)/ && ! /=\(/ { print $1 }' "$@"; }

#######################################
# checks if function is exported
# Globals:
#   FUNCNAME
# Arguments:
#   1   function name (default: ${FUNCNAME[0]})
# Returns:
#   1 if function is not exported,
#   0 if function is exported
#######################################
func_exported() {
  local arg="${1:-${FUNCNAME[0]}}"
  if ! declare -Fp "${arg}" 2>/dev/null | grep -q "declare -fx ${arg}" >/dev/null; then
    echo >&2 "${BASH_SOURCE[0]}: ${arg}: function not exported"
    return 1
  fi
}

if [ "${BASH_SOURCE##*/}" = "${0##*/}" ]; then
  set -eu
  [ "${1-}" != "functions" ] || { __shts_functions | sort; exit; }
  ${0%.*} "$@"
elif [ "${BATS_ROOT-}" ] || [ "${0##*/}.sh" = "${BASH_SOURCE[0]##*/}" ]; then
  # <html><h2>Bats Description Array</h2>
  # <p><strong><code>$SHTS_ARRAY</code></strong> created by bats::description() with $BATS_TEST_DESCRIPTION.</p>
  # </html>
  export SHTS_ARRAY=()

  # <html><h2>Git Top Basename</h2>
  # <p><strong><code>$SHTS_TOP_NAME</code></strong> basename of git top directory when sourced from a git dir.</p>
  # </html>
  export SHTS_BASENAME="${SHTS_TOP##*/}"

  # <html><h2>Test File Basename Without Suffix .bats</h2>
  # <p><strong><code>$SHTS_TEST_BASENAME</code></strong> from $BATS_TEST_FILENAME.</p>
  # </html>
  export SHTS_TEST_BASENAME="$(basename "${BATS_TEST_FILENAME-}" .bats | sed 's/.shts$//')"

  ! func_exported 2>/dev/null || return 0

  #######################################
  # creates $SHTS_ARRAY array from $BATS_TEST_DESCRIPTION or argument
  # Globals:
  #   SHTS_ARRAY
  #   BATS_TEST_DESCRIPTION
  #######################################
  # shellcheck disable=SC2086
  shts::array() { mapfile -t SHTS_ARRAY < <(xargs printf '%s\n' <<<${BATS_TEST_DESCRIPTION}); }

  #######################################
  # creates $SHTS_ARRAY array from $BATS_TEST_DESCRIPTION or argument
  # Globals:
  #   SHTS_ARRAY
  #   BATS_TEST_DESCRIPTION
  #######################################
  shts::basename() {
    basename "${BATS_TEST_FILENAME-}" .bats | sed 's/.shts$//';
    }

  #######################################
  # Changes to top repository path \$SHTS_TOP and top path found, otherwise changes to the \$SHTS_TESTS
  # Globals:
  #   BATS_ROOT
  #   SHTS_TESTS
  #   SHTS_TOP
  #######################################
  shts::cd() { [ ! "${BATS_ROOT-}" ] || cd "${SHTS_TOP:-${SHTS_TESTS}}" || return; }

  #######################################
  # create a temporary directory in $BATS_FILE_TMPDIR if arg is provided
  # Globals:
  #   BATS_FILE_TMPDIR
  # Arguments:
  #  1  directory name (default: returns $BATS_FILE_TMPDIR)
  # Outputs:
  #  new temporary directory or $BATS_FILE_TMPDIR
  #######################################
  shts::tmp() {
    local tmp="${BATS_FILE_TMPDIR}${1:+/${1}}"
    [ ! "${1-}" ] || mkdir -p "${tmp}"
    echo "${tmp}"
  }

  #######################################
  # run description array
  # Globals:
  #   SHTS_ARRAY
  # Arguments:
  #  None
  # Caution:
  #  Do not se it with single quotes ('echo "1 2" 3 4'), use double quotes ("echo '1 2' 3 4")
  #######################################
  shts::run() {
    shts::array
    run "${SHTS_ARRAY[@]}"
  }

  for i in bats-assert bats-file bats-support; do
    if ! . "${__brew_lib}/${i}/load.bash"; then
      >&2 echo "${BASH_SOURCE[0]}: ${__brew_lib}/${i}/load.bash: sourcing error"
      return 1
    fi
  done; unset i

  shts::cd
  envrc

  export -f $(__shts_functions)
  func_exported assert || return
fi
