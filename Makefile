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
		-v $(shell pwd)/pb:/go/src/protogo/pb \
		-v $(shell pwd)/Makefile:/go/src/protogo/Makefile \
		${PB_GEN} \
		make generate

PROTOC := protoc
INCDIR := -I . \
	-I vendor/github.com/envoyproxy/protoc-gen-validate \
# GO_OUT_OPTS := --go-grpc_out=. --go_out=.

generate: user

DIR := pb/user
user:
	${PROTOC} ${INCDIR} \
		--go-grpc_out=${DIR} --go_out=${DIR} \
		--validate_out="lang=go:${DIR}" \
		${DIR}/user.proto

clean:
	$(call echo_section,Clean)
	docker rmi -f ${PB_GEN}
