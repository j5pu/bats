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

BATS_BASH=$PROJECT_BATS_BASH$
BATS_NUMBER_OF_PARALLEL_JOBS=600
PATH="${BATS_BASH}/bin:${PATH}"
```

## [.envrc](.envrc)

````shell
BATS_BASH="$( cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd -P )"; export BATS_BASH
eval "$(awk 'FNR > 1 { print "export " $0 }' "${BATS_BASH}/.env" | grep -v "^$" | sed 's/^/export /g')"

````

## [tests_helper.bats](tests/helpers/helper.bash)

```shell
source bats.bats
```

## [test.bats](tests/bats.bash/func::exported.bats)

````shell
#!/usr/bin/env bats

setup_file() {
  load helpers/tests_helper
}
````
