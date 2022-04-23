#!/usr/bin/env bats

@test "${BATS_TEST_DIRNAME}/../fixtures/shebang/true.shts" {
  PATH="$(git rev-parse --show-toplevel)/bin:${PATH}" run "${BATS_TEST_DESCRIPTION}"
  [ $status -eq 0 ]
  [[ "$output" =~ true|SHTS_TESTS|SHTS_OUTPUT ]]
}
