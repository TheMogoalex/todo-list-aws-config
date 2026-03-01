#!/bin/bash
set -euo pipefail
set -x

# Si Jenkins no pasa ENVIRONMENT, usamos staging por defecto
ENVIRONMENT="${ENVIRONMENT:-staging}"
REGION="us-east-1"

if [[ "$ENVIRONMENT" == "staging" ]]; then
  STACK_NAME="todo-list-aws-staging"
elif [[ "$ENVIRONMENT" == "production" ]]; then
  STACK_NAME="todo-list-aws-production"
else
  echo "Unknown ENVIRONMENT: $ENVIRONMENT"
  exit 1
fi

# Desplegar el template buildado si existe; si no, el template raíz
TEMPLATE=".aws-sam/build/template.yaml"
if [[ ! -f "$TEMPLATE" ]]; then
  TEMPLATE="template.yaml"
fi

sam deploy \
  --template-file "$TEMPLATE" \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --resolve-s3 \
  --capabilities CAPABILITY_IAM \
  --no-confirm-changeset \
  --no-fail-on-empty-changeset