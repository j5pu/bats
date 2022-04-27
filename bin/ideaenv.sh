# shellcheck shell=bash

#
# Parses and .env file skipping first line and setting PROJECT_DIR or variable name if $PROJECT_DIR$

# Bats Number of Parallel Jobs
#
: "${BATS_NUMBER_OF_PARALLEL_JOBS=400}"; export BATS_NUMBER_OF_PARALLEL_JOBS

# Do not show messages when no .env file or git top path is found and return 0
#
: "${IDEAENV_QUIET=1}"

# Project Directory from git top or env file
#
export PROJECT_DIR

if [ "${BASH_SOURCE-}" ] && [ "${BASH_SOURCE[0]##*/}" = "${0##*/}" ]; then
  for arg; do
    case "${arg}" in
      -h|--help|help) rc=0 ;;
      *) >&2 echo -e "${0##*/}: ${arg}: invalid argument\n" ;;
    esac
  done
  >&2 cat << EOF
usage: . ${0##*/}
   or: ${0##*/} -h|-help|help

sources completions and .env file skipping first line if value is \$PROJECT_DIR\$, setting PROJECT_DIR or variable name

uses .env file in current work dir or git top repository path

if VARIABLE=\$PROJECT_DIR\$ in first line of .env file, VARIABLE is also set to \$PROJECT_DIR

if no env file is found, but git top path is found, \$PATH is updated with \$PROJECT_DIR/bin if exists

Commands:
   -h, --help, help  display this help and exit

Globals:
   BATS_NUMBER_OF_PARALLEL_JOBS   bats number of parallel jobs
   IDEAENV_QUIET                  do not show messages when no .env file or git top path is found and return 0
   PROJECT_DIR                    git top path or dirname of \$BASH_SOURCE or \$0, if VARIABLE=\$PROJECT_DIR\$
EOF
  exit "${rc:-1}"
fi

if test -f .env; then
  PROJECT_DIR="$(pwd)"
else
  PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || true)"
fi

_env="${PROJECT_DIR}/.env"

if [ -f "${_env}" ]; then
  _line=0
  if head -1 "${_env}" | grep -q "=\$PROJECT_DIR\$$"; then
    _variable="$(head -1 "${_env}" | cut -d '=' -f 1)"
    [ "${_variable}" = "PROJECT_DIR" ] || eval "export ${_variable}=${PROJECT_DIR}"
    _line=1
  fi
  unset _variable
  eval "$(awk -v l=$_line 'FNR > l { gsub("export ", ""); gsub("^", "export "); print }' "${_env}")" || return
  unset _env
elif test -d "${PROJECT_DIR}"; then
  ! test -d "${PROJECT_DIR}/bin" || [[ "${PATH}" =~ ${PROJECT_DIR}/bin: ]] || export PATH="${PROJECT_DIR}/bin:${PATH}"
elif test $IDEAENV_QUIET -eq 1; then
  unset _env; return
else
  >&2 echo "${BASH_SOURCE[0]##*/}: $(pwd): no .env file or git repository found"
  unset _env; return 1
fi

if [ "${PS1-}" ] && command -v complete >/dev/null; then
  for _file in "${PROJECT_DIR}/etc/bash_completion.d"/*; do
    test -f "${_file}" || break
    source "${_file}" || return
  done <>/dev/null
  unset _file
fi
