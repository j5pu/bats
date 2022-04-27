#!/usr/bin/env bats
# shellcheck disable=SC2034

setup_file() {
  load ../helpers/helper
  export HELP="sources completions and .env file skipping first line if value is \$PROJECT_DIR\$, setting PROJECT_DIR \
or variable name"
}

@test "${SHTS_TEST_BASENAME} " {
  shts::run
  assert_failure
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME} -h " {
  shts::run
  assert_success
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME} --help " {
  shts::run
  assert_success
  assert_line "${HELP}"
}

@test ". ${SHTS_TEST_BASENAME} " {
  shts::run
  assert_success
}

@test "cd ${BATS_TEST_DIRNAME}/../fixtures/env " {
  shts::array
  "${SHTS_ARRAY[@]}"
  . "${SHTS_TEST_BASENAME}"
  assert [ "${FOO}" = "${PROJECT_DIR}" ]

  run declare -p FOO
  assert_success
  assert_output "declare -x FOO=\"${PROJECT_DIR}\""

  run declare -p EXPORT
  assert_success
  assert_output "declare -x EXPORT=\"${BATS_NUMBER_OF_PARALLEL_JOBS}\""

  run declare -p BIN
  assert_success
  assert_output "declare -x BIN=\"${PROJECT_DIR}/bin:${USER}\""
}

@test "cd ${BATS_TEST_DIRNAME}/../fixtures " {
  top="${PROJECT_DIR}"
  jobs="${BATS_NUMBER_OF_PARALLEL_JOBS}"

  unset PROJECT_DIR BATS_NUMBER_OF_PARALLEL_JOBS
  ! complete -p "${SHTS_TEST_BASENAME}" &>/dev/null || complete -r "${SHTS_TEST_BASENAME}"

  shts::array
  "${SHTS_ARRAY[@]}"
  PS1="\$ " . "${SHTS_TEST_BASENAME}"
  assert_success

  assert [ "${top}" = "${PROJECT_DIR}" ]

  run declare -p PROJECT_DIR
  assert_success
  assert_output "declare -x PROJECT_DIR=\"${top}\""

  run declare -p BATS_NUMBER_OF_PARALLEL_JOBS
  assert_success
  assert_output "declare -x BATS_NUMBER_OF_PARALLEL_JOBS=\"${jobs}\""

  run complete -p  "${SHTS_TEST_BASENAME}"
  assert_success
}

@test "$(shts::tmp env) " {
  shts::array
  cd "${SHTS_ARRAY[@]}"

  . "${SHTS_TEST_BASENAME}"
  assert_success

  IDEAENV_QUIET=0 run sh -c ". ${SHTS_TEST_BASENAME}"
  assert_failure
  assert_output "${SHTS_TEST_BASENAME}: $(pwd): no .env file or git repository found"

  git init
  mkdir bin
  run sh -c ". ${SHTS_TEST_BASENAME}"
  assert_success
  run echo "${PATH}"
  assert_output --regexp "${PROJECT_DIR}/bin:"
}

# TODO: agregar al post install de shts.rb que se ejecute el brew compgen.
# TODO: acabar con lo que estaba del symlink de JetBrains
# TODO: ver que hago con los alias de directorios de homebrew-tap, etc. y variables.
# TODO: ver que coño hago con el comando que instale todo y las formulas. y ver si pongo el IDEA...
