#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

@test "echo '1 2' 3 4 5 " {
  bats::run::description
  assert_output - <<EOF
1 2 3 4 5
EOF
}

@test "echo \"1 2\" 3 4 5 " {
  bats::run::description
  >&3 echo "$output"
  assert_output - <<EOF
1 2 3 4 5
EOF
}

@test "ls -1 '1 2' 3 4 5 " {
  tmp="$(mktemp -d)"
  cd "${tmp}"
  touch "1 2"
  touch 3
  touch 4
  touch 5
  bats::run::description
  assert_output - <<EOF
1 2
3
4
5
EOF
}

@test "ls -1 \"1 2\" 3 4 5 " {
  tmp="$(mktemp -d)"
  cd "${tmp}"
  touch "1 2"
  touch 3
  touch 4
  touch 5
  bats::run::description
  assert_output - <<EOF
1 2
3
4
5
EOF
}
