#!/bin/bash
set -euo pipefail
BASE_URL="$1"
set -x

# El test usa BASE_URL en env
export BASE_URL="$BASE_URL"

# Ejecuta SOLO los tests marcados como read-only
python3 -m pytest -q -m readonly test/integration/todoApiTest.py