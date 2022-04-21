#!/usr/bin/env bats

setup_file() {
  load ../helpers/helper
  export HELP="bats testing wrapper and helper functions"
  export OUTPUT="${SHTS_TOP}/.output"
}

teardown_file() { ! test -d "${OUTPUT}" || rm -rf "${OUTPUT}"; }

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

@test "${SHTS_TEST_BASENAME} help " {
  shts::run
  assert_success
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME} commands " {
  shts::run
  assert_success
  assert_output - <<EOF
--help
-h
commands
help
list
verbose
EOF
}

@test "${SHTS_TEST_BASENAME} list " {
  shts::run
  assert_success
  assert_line assert
  assert_line envrc
  assert_line shts::array
}

@test "${SHTS_TEST_BASENAME} tests/repo " {
  shts::run
  assert_success
}

@test "${SHTS_TEST_BASENAME} verbose tests/repo " {
  shts::run
  assert_success
  assert_dir_exist "${OUTPUT}"
}

@test "${SHTS_TEST_BASENAME} tests/repo verbose " {
  shts::run
  assert_success
  assert_dir_exist "${OUTPUT}"
}

@test "${SHTS_TEST_BASENAME} tests/repo/tests/test.bats " {
  shts::run
  assert_success
}

@test "sh -c 'cd tests/repo/${SHTS_TEST_BASENAME} && ${SHTS_TEST_BASENAME}' " {
  shts::run
  assert_sucess
}

@test "${SHTS_TEST_BASENAME} /tmp " {
  shts::run
  assert_failure
  assert_line "${HELP}"
  assert_line "${SHTS_TEST_BASENAME}: foo: invalid argument/test path"
}

@test "${SHTS_TEST_BASENAME} foo " {
  shts::run
  assert_failure
  assert_line "${HELP}"
  assert_line "${SHTS_TEST_BASENAME}: foo: invalid argument/test path"
}

@test "${SHTS_TEST_BASENAME}.sh " {
  shts::run
  assert_failure
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME}.sh -h " {
  shts::run
  assert_success
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME}.sh --help " {
  shts::run
  assert_success
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME}.sh help " {
  shts::run
  assert_success
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME}.sh commands " {
  shts::run
  assert_success
  assert_output - <<EOF
--help
-h
commands
help
list
verbose
EOF
}

@test "${SHTS_TEST_BASENAME}.sh list " {
  shts::run
  assert_success
  assert_line assert
  assert_line envrc
  assert_line shts::array
}

@test "${SHTS_TEST_BASENAME}.sh tests/repo " {
  shts::run
  assert_success
}

@test "${SHTS_TEST_BASENAME}.sh verbose tests/repo " {
  shts::run
  assert_success
  assert_dir_exist "${OUTPUT}"
}

@test "${SHTS_TEST_BASENAME}.sh tests/repo verbose " {
  shts::run
  assert_success
  assert_dir_exist "${OUTPUT}"
}

@test "${SHTS_TEST_BASENAME}.sh tests/repo/tests/test.bats " {
  shts::run
  assert_success
}

@test "sh -c 'cd tests/repo/${SHTS_TEST_BASENAME} && ${SHTS_TEST_BASENAME}.sh' " {
  shts::run
  assert_sucess
}

@test "${SHTS_TEST_BASENAME}.sh /tmp " {
  shts::run
  assert_failure
  assert_line "${HELP}"
  assert_line "${SHTS_TEST_BASENAME}: foo: invalid argument/test path"
}

@test "${SHTS_TEST_BASENAME}.sh foo " {
  shts::run
  assert_failure
  assert_line "${HELP}"
  assert_line "${SHTS_TEST_BASENAME}: foo: invalid argument/test path"
}
