FROM golang:1.18.0-alpine3.15

RUN apk update && apk add \
    make \
    protoc=3.18.1-r1

WORKDIR /go/src/protogo

COPY go.mod .
COPY go.sum .

RUN go mod download && \
    go install \
        google.golang.org/protobuf/cmd/protoc-gen-go \
        google.golang.org/grpc/cmd/protoc-gen-go-grpc && \
    # NOTE: installation of protoc-gen-validate requires running `make build`, which
    # only doable when protoc-gen-validate is in $GOPATH, which is not possible when
    # `go mod` is used to manage version. The below two commands basically does what
    # `make build` does, using the code repo in mod directory.
    (cd /go/pkg/mod/github.com/envoyproxy/protoc-gen-validate@v0.6.1 && make validate/validate.pb.go) && \
    go install github.com/envoyproxy/protoc-gen-validate
