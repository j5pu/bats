# shellcheck shell=bash

#
# Parses and .env file skipping first line and setting PROJECT_DIR or variable name if $PROJECT_DIR$

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

sources .env file skipping first line if value is \$PROJECT_DIR\$, setting PROJECT_DIR or variable name

if VARIABLE=\$PROJECT_DIR\$ in first line of .env file, VARIABLE is also set to \$PROJECT_DIR

Commands:
   -h, --help, help  display this help and exit

Globals:
   PROJECT_DIR       git top path or dirname of \$BASH_SOURCE or \$0, if variable=\$PROJECT_DIR\$
EOF
  exit "${rc:-1}"
fi

PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || dirname "$(realpath "${BASH_SOURCE:-$0}")")"
export PROJECT_DIR

_l=0
if head -1 "${PROJECT_DIR}/.env" || return | grep -q "=\$PROJECT_DIR\$$"; then
  _n="$(head -1 "${PROJECT_DIR}/.env" | cut -d '=' -f 1)"
  [ "${_n}" = "PROJECT_DIR" ] || eval "export ${_n}=${PROJECT_DIR}"
  _l=1
fi

awk -v l=$_l 'FNR > l { gsub("export ", ""); gsub("^", "export "); print }' "${PROJECT_DIR}/.env"
unset _l _n
