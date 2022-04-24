#!/usr/bin/env bats

setup_file() {
  load ../helpers/helper
  export HELP="sources .env file skipping first line if value is \$PROJECT_DIR\$, setting PROJECT_DIR or variable name"
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
}
$BATS_FILE_EXTENSION
