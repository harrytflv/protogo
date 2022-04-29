# Proto Go

Setup of Go code generation from `.proto` files.

## Design Goals

### Previous Goals
* Developers implmenting gRPC services given the interface should not need to generate code from `.proto` files.
* Developers doing slight modifications on a given API should only need to run a `make` command to update the API.
* Only Docker and GNU make are required in development environment.
* Support importing `.proto` files from other services.

### New Enhancements
* Developers creating new gRPC services should need to worry about setup the code generation environment as long as no new third-party imports are needed.
* Support importing third-party `.proto` files.

## Design Idea
Build a generator image with all tools and dependencies, and execute code generation within container.

## Development Guide

### New API

1. Create directory for that new service.
2. Define service as `.proto` files.
3. Change `Makefile`:
* Append to this list:
```
generate: user group
```
* Append generate calls, like this:
```
group:
	$(call generate,pb/group/group.proto)
```
4. Run `make`

### Slight modification on gRPC API

Run `make`.

### Changing only implementation

No action required.

### Adding new third-party dependencies

1. Add the package import to `tools/tools.go` so that version can be managed using go mod.
2. Run `go mod tidy`.
3. Edit `build/generator/Dockerfile` so that the third-party dependency can be used in genenrator container.
