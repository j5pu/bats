# shellcheck shell=sh

#
# Remove Duplicates in PATH

PATH="$(echo "${PATH}" | tr ':' '\n' | uniq | tr '\n' ':' | sed 's/:$//')"
