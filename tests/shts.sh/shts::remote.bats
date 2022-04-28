#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

commit() {
  shts::run
  assert_success
  touch README.md
  git add README.md
  git -C "${SHTS_REMOTE[0]}" commit -m "test"
  git push
}

@test "shts::remote " {
  run commit
  assert_success

  run echo "${SHTS_REMOTE[0]##*/}"
  assert_output "${SHTS_REMOTE[1]##*/}"
}

@test "shts::remote foo " {
  run commit
  assert_success

  assert_equal "${SHTS_REMOTE[0]##*/}" "${SHTS_REMOTE[1]##*/}"
}
