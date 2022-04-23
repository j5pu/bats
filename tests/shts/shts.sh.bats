#!/usr/bin/env bats

setup_file() {
  load ../helpers/helper
  export HELP="bats testing wrapper and helper functions when \"${SHTS_TEST_BASENAME}\" sourced"
}

teardown_file() { ! test -d "${SHTS_OUTPUT}" || rm -rf "${SHTS_OUTPUT}"; }

@test "\$SHTS_TESTS " { assert_dir_exist "${SHTS_TESTS}"; }

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
functions
help
list
EOF
}

@test "${SHTS_TEST_BASENAME} functions " {
  shts::run
  assert_success
  assert_line assert
  assert_line envrc
  assert_line shts::array
}

@test "${SHTS_TEST_BASENAME} list " {
  shts::run
  assert_success
  assert_line --regex "${BATS_TEST_FILENAME}"
}

@test "${SHTS_TEST_BASENAME} tests/fixtures " {
  shts::run
  assert_success
}

@test "${SHTS_TEST_BASENAME} --verbose tests/fixtures " {
  shts::run
  assert_success
  assert_line "# \$\$ run \"\${SHTS_ARRAY[@]}\""
}

@test "${SHTS_TEST_BASENAME} tests/fixtures --verbose " {
  shts::run
  assert_success
  assert_line "# \$\$ run \"\${SHTS_ARRAY[@]}\""
}

@test "${SHTS_TEST_BASENAME} tests/fixtures/tests/test.bats " {
  shts::run
  assert_success
}

@test "sh -c 'cd tests/fixtures/${SHTS_TEST_BASENAME} && ${SHTS_TEST_BASENAME}' " {
  shts::run
  assert_success
}

@test "${SHTS_TEST_BASENAME} /tmp " {
  shts::run
  assert_failure
  assert_line "${HELP}"
  assert_line "${SHTS_TEST_BASENAME}: /tmp: invalid argument/test path"
}

@test "${SHTS_TEST_BASENAME} foo " {
  shts::run
  assert_failure
  assert_line "${HELP}"
  assert_line "${SHTS_TEST_BASENAME}: foo: invalid argument/test path"
}
