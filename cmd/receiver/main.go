package main

import (
	"context"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"log"
)

type Response struct {
	Message string `json:"message"`
}

func main() {
	lambda.Start(handleRequest)
}

func handleRequest(ctx context.Context, sqsEvent events.SQSEvent) (Response, error) {
	select {
	case <-ctx.Done():
		return Response{}, ctx.Err()
	default:
	}
	process(sqsEvent.Records);
	return Response{Message: "successfully processed message"}, nil
}

func process(records []events.SQSMessage) {
	for _, sqsMsg := range records {
		log.Printf("received message id: %s and body: %s", sqsMsg.MessageId, sqsMsg.Body)
	}
}

