#!/bin/sh
#

set -eu

function assert_has_carthage() {
  if ! command -v carthage; then
      echo "cli build needs 'carthage' to bootstrap dependencies"
      echo "You can install it using brew. E.g. $ brew install carthage"
      exit 1;
  fi
}

function build_cli_deps() {
  assert_has_carthage
  if [[ $PROJECT =~ .*UIAWebDriverAgent/.* ]]
  then
    pushd ./UIAWebDriverAgent
    carthage checkout
    popd
  else
    carthage checkout
    carthage build ocmock --platform iOS
  fi
}

function build() {
  if [ $ACTION="run-tests" ]; then
    xctool \
        -project $PROJECT \
        -scheme $TARGET \
        -sdk $SDK \
        build-tests \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO
  fi
  xctool \
      -project $PROJECT \
      -scheme $TARGET \
      -sdk $SDK \
      $ACTION \
      CODE_SIGN_IDENTITY="" \
      CODE_SIGNING_REQUIRED=NO
}

build_cli_deps
build
