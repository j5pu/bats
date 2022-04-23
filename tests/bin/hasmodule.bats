#!/usr/bin/env bats

setup_file() {
  load ../helpers/helper
  export HELP="check is python module is installed, no argument is help"
}

@test "${SHTS_TEST_BASENAME} " {
  shts::run
  assert_failure
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

@test "${SHTS_TEST_BASENAME} help " {
  shts::run
  assert_success
  assert_line "${HELP}"
}

@test "${SHTS_TEST_BASENAME} pip " {
  shts::run
  assert_success
}

@test "${SHTS_TEST_BASENAME} foo " {
  shts::run
  assert_failure
}
