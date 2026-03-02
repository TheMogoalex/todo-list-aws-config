#!/bin/bash
set -euo pipefail
BASE_URL="$1"
set -x

# El test usa BASE_URL en env
export BASE_URL="$BASE_URL"

mkdir -p reports

if [[ ! -f "todo-list-aws/bin/activate" ]]; then
  echo "Virtualenv not found. Creating it for read-only integration tests..."
  rm -rf todo-list-aws
  python3 -m venv todo-list-aws
  source todo-list-aws/bin/activate
  python -m pip install --upgrade pip
  python -m pip install -q pytest requests unittest-xml-reporting
else
  source todo-list-aws/bin/activate
fi

python3 -m pytest -q -m readonly test/integration/todoApiTest.py \
  --junitxml=reports/integration-readonly-junit.xml