#!/usr/bin/env bats

setup_file() { load ../helpers/helper; }

@test "bats::array " {
  ${BATS_TEST_DESCRIPTION}
  assert_equal "$(printf '%s ' "${BATS_ARRAY[@]}")" "${BATS_TEST_DESCRIPTION}"
}

@test "bats::array foo boo " {
  bats::array
  assert_equal "${#BATS_ARRAY[@]}" 3
}

@test "bats::array 1 2 3 " {
  bats::array
  assert_equal "${#BATS_ARRAY[@]}" 4
}

@test "bats::array '1 2' 3 4 5 " {
  bats::array
  export BATS_ARRAY
  run declare -p BATS_ARRAY
  assert_output <<EOF
declare -a BATS_ARRAY=([0]="bats::array" [1]="1 2" [2]="3" [3]="4" [4]="5")
EOF
}

@test 'bats::array "1 2" 3 4 5 ' {
  bats::array
  export BATS_ARRAY
  run declare -p BATS_ARRAY
  assert_output <<EOF
declare -a BATS_ARRAY=([0]="bats::array" [1]="1 2" [2]="3" [3]="4" [4]="5")
EOF
}

@test "bats::array \"1 2 3\" 4 5 6 " {
  bats::array
  export BATS_ARRAY
  run declare -p BATS_ARRAY
  assert_output <<EOF
declare -a BATS_ARRAY=([0]="bats::array" [1]="1 2 3" [2]="4" [3]="5" [4]="6")
EOF
}
