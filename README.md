## Design Goals
* Developers implmenting gRPC services given the interface should not need to generate code from `.proto` files.
* Developers doing slight modifications on a given API should only need to run a `make` command to update the API.
* Only Docker and GNU make are required in development environment.
* Capable of only make on a subset of `.proto` files by running `make $TARGET`, for example, `make user`.
* Support importing third-party `.proto` files.
* Support importing `.proto` files from other services