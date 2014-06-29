#!/bin/bash
cd "$(dirname "$0")"

if [ ! -d ./bin ]; then
  mkdir -p ./bin
fi

# Ensure we fail immediately if any command fails.
set -e

pushd ./bin > /dev/null
  cmake -DCMAKE_BUILD_TYPE=Debug ..
  VERBOSE=1 make
popd

# Run the tests
./bin/ovr_test
