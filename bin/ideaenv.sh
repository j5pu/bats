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

uses .env file in current work dir or git top repository path

if VARIABLE=\$PROJECT_DIR\$ in first line of .env file, VARIABLE is also set to \$PROJECT_DIR

Commands:
   -h, --help, help  display this help and exit

Globals:
   PROJECT_DIR       git top path or dirname of \$BASH_SOURCE or \$0, if VARIABLE=\$PROJECT_DIR\$
EOF
  exit "${rc:-1}"
fi

_env="$(pwd)/.env"
[ -f "${_env}" ] || _env="$(git rev-parse --show-toplevel)/.env"
[ -f "${_env}" ] || { >&2 echo "${0##*/}: $(pwd): no .env file found"; unset _env; return 1; }


PROJECT_DIR="$(dirname "${_env}")"; export PROJECT_DIR

_line=0
if head -1 "${_env}" | grep -q "=\$PROJECT_DIR\$$"; then
  _variable="$(head -1 "${_env}" | cut -d '=' -f 1)"
  [ "${_variable}" = "PROJECT_DIR" ] || eval "export ${_variable}=${PROJECT_DIR}"
  _line=1
fi
unset _variable

eval "$(awk -v l=$_line 'FNR > l { gsub("export ", ""); gsub("^", "export "); print }' "${_env}")"
unset _env _line
