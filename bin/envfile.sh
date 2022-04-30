# shellcheck shell=bash disable=SC2001

#
# sources .envfile in current working or git top path, calls direnv hook and sources completions

[ "${BASH_SOURCE-}" ] || return

# Project Directory from git top or env file
#
export PROJECT_DIR

#######################################
# sources .envfile in current working or git top path, calls direnv hook and sources completions
# Globals:
#   PATH
#   PROJECT_DIR
#   PS1
# Arguments:
#  None
# Returns:
#   $rc
#######################################
envfile() {
  local rc=$? envfile file line tmp variable

  if [ ! "${__ENVFILE_SET-}" ]; then
    __ENVFILE_SET="$(set)"

    PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    envfile="$(
      while true; do
        [ ! -f ".envfile" ] || { echo "${PWD}/.envfile"; break; }
        [ "${PWD}" != "${PROJECT_DIR}" ] || break
        cd ..
      done
    )"
    envfile="$(find_up .envfile "${PROJECT_DIR}" 2>/dev/null || echo "${PROJECT_DIR}/.envfile")"

    if [ -f "${envfile}" ]; then
      [ ! "${PS1-}" ] || >&2 echo "envfile: loading $(echo "${envfile}" | sed "s|${HOME}|~|")"

      line=0
      if head -1 "${envfile}" | grep -q "=\$PROJECT_DIR\$$"; then
        variable="$(head -1 "${envfile}" | cut -d '=' -f 1)"
        [ "${variable}" = "PROJECT_DIR" ] || eval "export ${variable}=${PROJECT_DIR}"
        line=1
      fi
      eval "$(awk -v l=$line 'FNR > l { gsub("export ", ""); gsub("^", "export "); print }' "${envfile}")" || return
      PATH="$(echo "${PATH}" | tr ':' '\n' | uniq | tr '\n' ':' | sed 's/:$//')"
    fi
    ! test -d "${PROJECT_DIR}/bin" || [[ "${PATH}" =~ ${PROJECT_DIR}/bin: ]] || export PATH="${PROJECT_DIR}/bin:${PATH}"
  fi

  tmp="$(mktemp)"
  eval "$(direnv export bash 2>"${tmp}")"
  case "$(cat "${tmp}")" in
    *"direnv allow"*)
      direnv allow
      envfile
      [ ! "${PS1-}" ] || >&2 echo "envfile: allowed"
      ;;
    *"direnv: loading"*)
      [ ! "${PS1-}" ] || grep -E "^direnv: loading|^direnv: export" "${tmp}"
      if [ "${PS1-}" ] && command -v complete >/dev/null; then
        for file in "${PROJECT_DIR}/etc/bash_completion.d"/*; do
          test -f "${file}" || break
          source "${file}" || return
        done <>/dev/null
      fi
      ;;
    *"direnv: unloading"*)
      [ ! "${PS1-}" ] || >&2 echo "envfile: unloading"
      eval echo "${__ENVFILE_SET}" 2>&1 | grep -vE 'BASH|readonly' || true
      unset __ENVFILE_SET
      ;;
    *) cat "${tmp}" ;;
  esac
  rm -f "${tmp}"

  return $rc
}
__ENVFILE_SET=

export -f envfile
export starship_precmd_user_func="envfile"

if [ "${BASH_SOURCE[0]##*/}" = "${0##*/}" ]; then
  for arg; do
    case "${arg}" in
      -h|--help|help) code=0 ;;
      hook) cat "$0"; exit ;;
      *) >&2 echo -e "${0##*/}: ${arg}: invalid argument\n" ;;
    esac
  done
  >&2 cat << EOF
usage: . ${0##*/}
   or: ${0##*/} -h|-help|help

sources .envfile in current working or git top path, calls direnv hook and sources completions

if VARIABLE=\$PROJECT_DIR\$ in first line of .envfile file, VARIABLE is also set to \$PROJECT_DIR

if no .envfile file is found, but git top path is found, \$PATH is updated with \$PROJECT_DIR/bin if exists

Commands:
   -h, --help, help               display this help and exit
   hook                           display the hook script
Globals:
   BATS_NUMBER_OF_PARALLEL_JOBS   bats number of parallel jobs
   PROJECT_DIR                    git top path or dirname of \$BASH_SOURCE or \$0, if VARIABLE=\$PROJECT_DIR\$
EOF
  exit "${code:-1}"
fi

