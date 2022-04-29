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
		-v $(shell pwd):/go/src/github.com/harrytflv/protogo \
		${PB_GEN} \
		make generate

PROTOC := protoc
INCDIR := -I . \
	-I ${GOPATH}/pkg/mod/github.com/envoyproxy/protoc-gen-validate@v0.6.7 \

generate = ${PROTOC} ${INCDIR} \
	--go-grpc_out=${GOPATH}/src --go_out=${GOPATH}/src \
	$1


generate_validate = ${PROTOC} ${INCDIR} \
	--validate_out="lang=go:${GOPATH}/src" \
	$1

generate: user group

user:
	$(call generate,pb/user/user.proto)
	$(call generate_validate,pb/user/user.proto)

group:
	$(call generate,pb/group/group.proto)

clean:
	$(call echo_section,Clean)
	docker rmi -f ${PB_GEN}
