#!/bin/bash

set -e

echo "Running all executable test scripts starting with test- and ending with .sh in test/..."

./test/test-api-endpoint.sh
./test/test-unsubscribe-validation.sh

echo "All tests completed successfully."
