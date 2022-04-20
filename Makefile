all: generate_by_generator

CURRENT_UID ?= $(shell id -u)
CURRENT_GID ?= $(shell id -g)
IMAGE_PREFIX := harrytflv/
PB_GEN := ${IMAGE_PREFIX}gopbgen:latest

echo_section = @echo "\e[1;34m[$1]\e[0m"

generator_image:
	$(call echo_section,Build generator docker image)
	docker build -t ${PB_GEN} -f build/generator/Dockerfile .

generate_by_generator: generator_image
	$(call echo_section,Generate Go files using generator)
	docker run --rm \
		--user ${CURRENT_UID}:${CURRENT_GID} \
		-v $(shell pwd):/go/src/protogo \
		${PB_GEN} \
		make generate

PROTOC := protoc
INCDIR := -I .
GO_OUT_OPTS := --go-grpc_out=. --go_out=.

generate: pb_go

pb_go:
	${PROTOC} ${INCDIR} ${GO_OUT_OPTS} \
		pb/user/user.proto 

clean:
	$(call echo_section,Clean)
	docker rmi -f ${PB_GEN}
