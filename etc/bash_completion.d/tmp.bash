# shellcheck shell=bash disable=SC2207

#######################################
# bats.bash completions
# Globals:
#   COMPREPLY
# Arguments:
#   1     name of the command whose arguments are being completed
#   2     word being completed ("cur")
#   3     word preceding the word being completed or $1 when is the first word ("prev")
#######################################
_bats_bash() {
  [ "$1" = "$3" ] || return 0
  mapfile -t COMPREPLY < <(compgen -o nospace -W "$("$1" commands) -h --help help" -- "$2")

  COMPREPLY=($(compgen -o nospace -W "$("$1" commands)" -- "$2"))
}

complete -F _bats_bash bats.bash

#######################################
# secrets completions
# Globals:
#   COMPREPLY
# Arguments:
#   1     name of the command whose arguments are being completed
#   2     word being completed ("cur")
#   3     word preceding the word being completed or $1 when is the first word ("prev")
#######################################
_release() {
  local command_expect_argument=true reply

  local commands_expect_message=(feat "feat!" fix "fix!")
  local commands_function_and_exit=(tests tools)
  local commands_no_dry_run=(commands -h --help help)
  local dry=(--dry-run)

  for arg in "${COMP_WORDS[@]:1:COMP_CWORD-1}"; do
    case "${arg}" in
      commands|-h|--help|help)
        commands_expect_message=()
        commands_function_and_exit=()
        commands_no_dry_run=()
        dry=()
        ;;
      --dry-run)
        commands_no_dry_run=()
        dry=()
        ;;
      feat!|fix!|tests|tools)
        commands_expect_message=()
        commands_function_and_exit=()
        commands_no_dry_run=()
        ;;
      feat|fix)
        command_expect_argument=false
        commands_function_and_exit=()
        commands_no_dry_run=()
        ;;
      *)
        commands_expect_message=()
        commands_function_and_exit=()
        commands_no_dry_run=()
        ;;
    esac
  done
  $command_expect_argument || commands_expect_message=()
  reply=("${commands_expect_message[@]}" "${commands_function_and_exit[@]}" "${commands_no_dry_run[@]}" "${dry[@]}")
  mapfile -t COMPREPLY < <(compgen -W "${reply[*]}" -- "$2")
}

#######################################
# secrets completions
# Globals:
#   COMPREPLY
# Arguments:
#   1     name of the command whose arguments are being completed
#   2     word being completed ("cur")
#   3     word preceding the word being completed or $1 when is the first word ("prev")
#######################################
_pyuninstall() {
  local packages
  if [[ $COMP_CWORD -eq 1 ]]; then
      mapfile -t COMPREPLY < <(compgen -o nospace -W "-h --help help $(pypackages | grep -v pip)" -- "$2")
  else
    ! [[ "${COMP_WORDS[1]}" =~ -h|--help|help ]] || return 0
    packages="$(comm -3 <(pypackages | grep -v pip) <(printf '%s\n' "${COMP_WORDS[@]:1:COMP_CWORD-1}" | sort))"
    [ "${packages-}" ] || return 0
    mapfile -t COMPREPLY < <(compgen -W "${packages}" -- "$2")
  fi
}

#######################################
# pyinstall
# Globals:
#   COMPREPLY
# Arguments:
#   1     name of the command whose arguments are being completed
#   2     word being completed ("cur")
#   3     word preceding the word being completed or $1 when is the first word ("prev")
#######################################
_pyinstall() {
  [ "${COMP_CWORD}" -ne 1 ] || local help=" help"

  ! [[ "${COMP_WORDS[1]}" =~ -h|--help|help ]] || return 0
  local command_opts
  command_opts=$(pip3 install --help | grep -E -o "((-\w{1}|--(\w|-)*=?)){1,2}")
  mapfile -t COMPREPLY < <(compgen -W "${command_opts}${help}" -- "$2")
}
