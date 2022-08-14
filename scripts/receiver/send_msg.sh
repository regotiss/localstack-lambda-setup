#!/usr/bin/env bash

LAMBDA_NAME="receiver"

laws="aws --endpoint-url=http://localhost:4566"
export AWS_DEFAULT_REGION=us-east-1

echo "Sending message to ${LAMBDA_NAME} queue"
$laws sqs send-message \
  --queue-url http://localhost:4566/000000000000/${LAMBDA_NAME}-queue \
  --message-body "$(cat ./scripts/receiver/msg_body.json)" \
  --message-attributes "$(cat ./scripts/receiver/msg_attributes.json)"

echo "Waiting few seconds to trigger lambda"
sleep 2

echo "Watching lambda logs"
$laws logs tail "/aws/lambda/${LAMBDA_NAME}-lambda" --follow

