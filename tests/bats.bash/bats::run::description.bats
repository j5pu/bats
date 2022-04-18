#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

@test "echo '1 2' 3 4 5 " {
  bats::run::description
  assert_output <<EOF
"1 2" 3 4 5
EOF
}

@test "echo \"1 2\" 3 4 5 " {
  bats::run::description
  assert_output <<EOF
"1 2" 3 4 5
EOF
}

@test 'echo "1 2" 3 4 5 ' {
  bats::run::description
  assert_output <<EOF
"1 2" 3 4 5
EOF
}
