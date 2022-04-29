//go:build tools

package tools

import (
	// Required to do validation in grpc.
	_ "github.com/envoyproxy/protoc-gen-validate"

	// Required for using grpc in go.
	_ "google.golang.org/grpc"
	_ "google.golang.org/grpc/cmd/protoc-gen-go-grpc"
	_ "google.golang.org/protobuf/cmd/protoc-gen-go"
)
