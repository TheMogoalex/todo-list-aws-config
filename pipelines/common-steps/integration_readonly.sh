#!/bin/bash
set -euo pipefail
BASE_URL="$1"
set -x

# 1) LIST (solo lectura)
http=$(curl -s -o /tmp/list.json -w "%{http_code}" "$BASE_URL/todos")
test "$http" = "200"
cat /tmp/list.json

# 2) GET por id (solo si hay algún elemento)
python3 - <<'PY'
import json,sys
p="/tmp/list.json"
data=json.load(open(p))
if isinstance(data, list) and len(data)>0 and "id" in data[0]:
    print(data[0]["id"])
PY
ID=$(python3 - <<'PY'
import json
data=json.load(open("/tmp/list.json"))
print(data[0]["id"] if isinstance(data,list) and data and "id" in data[0] else "")
PY
)

if [ -n "$ID" ]; then
  http=$(curl -s -o /tmp/get.json -w "%{http_code}" "$BASE_URL/todos/$ID")
  test "$http" = "200"
  cat /tmp/get.json
else
  echo "No hay items; se valida solo LIST."
fi