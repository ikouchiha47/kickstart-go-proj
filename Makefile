VERSION ?= latest

gen.models.proto:
	( cd protos && \
		protoc --go_out=../app/core --go_opt=paths=source_relative \
		--go-grpc_out=../app/core --go-grpc_opt=paths=source_relative \
		./**/*.proto \
	)

gen.web.proto:
	( protoc -I protos/web \
		-I protos/includes/googleapis \
		-I protos/includes/grpc_ecosystem \
		--openapiv2_out ./openapiv2 --openapiv2_opt logtostderr=true \
		./protos/web/**/*.proto \
	)

go.test:
	go test -timeout=20s ./...

serve.docs: gen.web.proto
	( bash ./build.docs.sh )


build.server:
	go build -o out/server cmd/server/main.go

build.worker:
	go build -o out/worker cmd/worker/main.go

build: build.server build.worker

