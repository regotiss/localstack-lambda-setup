#!/usr/bin/env bash

LAMBDA_NAME="receiver"
export AWS_DEFAULT_REGION=us-east-1

echo "Building ${LAMBDA_NAME} executable"
GOOS=linux go build ./cmd/${LAMBDA_NAME}/main.go

echo "Packaging executable"
zip deployment.zip main; rm main


laws="aws --endpoint-url=http://localhost:4566"

QUEUE_NAME="${LAMBDA_NAME}-queue"

echo "Creating ${QUEUE_NAME}"
$laws sqs create-queue --queue-name ${QUEUE_NAME}

echo "Deleting lambda if already exists"
$laws lambda delete-function --function-name ${LAMBDA_NAME}-lambda > /dev/null 2>&1

echo "Creating ${LAMBDA_NAME} lambda"
$laws lambda create-function --function-name ${LAMBDA_NAME}-lambda \
 --runtime go1.x --handler main --zip-file fileb://deployment.zip \
 --role any-role

echo "Creating event source mapping between ${LAMBDA_NAME} queue and lambda"
$laws lambda create-event-source-mapping \
 --event-source-arn arn:aws:sqs:${AWS_DEFAULT_REGION}:000000000000:${QUEUE_NAME} \
 --function-name ${LAMBDA_NAME}-lambda

echo "Done"

