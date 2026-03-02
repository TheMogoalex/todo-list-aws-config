#!/bin/bash
set -euo pipefail
BASE_URL="$1"
set -x

# El test usa BASE_URL en env
export BASE_URL="$BASE_URL"

mkdir -p reports

source todo-list-aws/bin/activate

python3 -m pytest -q -m readonly test/integration/todoApiTest.py \
  --junitxml=reports/integration-readonly-junit.xml