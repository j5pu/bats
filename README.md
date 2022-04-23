# [bats.bash](https://github.com/j5pu/bats.bash)


![shrc](./.idea/icon.svg)

[![Build Status](https://github.com/j5pu/bats.bash/workflows/main/badge.svg)](https://github.com/j5pu/bats.bash/actions/workflows/main.yaml)

[![tap](https://github.com/j5pu/homebrew-tap/workflows/main/badge.svg)](https://github.com/j5pu/homebrew-tap/actions)

[Bats Helpers](./bin/bats.bash)


## Install

````shell
brew install j5pu/tap/shrc
bats.bash --help
````

## JetBrains

![PathVariables.png](./.idea/assets/Path%20Variables.png)
![Terminal.png](./.idea/assets/Terminal.png)

## [.env](.env)

```shell
# shellcheck disable=SC2034

PROJECT_DIR=$PROJECT_DIR$
BATS_NUMBER_OF_PARALLEL_JOBS=600
PATH="${PROJECT_DIR}/bin:${PATH}"
```

## [.envrc](.envrc)

````shell
PROJECT_DIR="$( cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd -P )"; export PROJECT_DIR
eval "$(awk 'FNR > 1 { print "export " $0 }' "${PROJECT_DIR}/.env" | grep -v "^$" | sed 's/^/export /g')"

````
### Usage

#### [shebang](./tests/fixtures/env/true.shts)

````shell
#!/usr/bin/env shts
#shellcheck shell=bats

@test "$(shts::basename) " { shts::run; assert_success; }
````

#### [setup_file](./bin/shts.sh)

````shell
#!/usr/bin/env bats

setup_file() { source shts.sh; }

@test "${SHTS_TEST_BASENAME} " { shts::run; assert_success; }
````

#### [helper](tests/helpers/helper.bash)

##### [tests_helper.bats](tests/helpers/helper.bash)

```shell
# shellcheck shell=bash
source shts.sh
```

##### [test.bats](tests/shts.sh/func_exported.bats)

````shell
#!/usr/bin/env bats

setup_file() { load helpers/tests_helper; }

@test "${SHTS_TEST_BASENAME} " { shts::run; assert_success; }
````
