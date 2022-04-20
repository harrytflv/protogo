FROM golang:1.18.0-alpine3.15

RUN apk update && apk add \
    make \
    protoc=3.18.1-r1

WORKDIR /go/src/protogo

COPY go.mod .
COPY go.sum .

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go \
        google.golang.org/grpc/cmd/protoc-gen-go-grpc
