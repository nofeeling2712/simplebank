postgres:
	docker run --name postgres12 -p 5433:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose up
	
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5433/simple_bank?sslmode=disable" -verbose down

test:
	go test -v -cover ./...

sqcinit:
	docker run --rm -v ${pwd}:/src -w /src kjconroy/sqlc init

sqcgenerate:
	docker run --rm -v ${pwd}:/src -w /src kjconroy/sqlc generate

server:
	go run main.go

.PHONY: postgres createdb dropdb migrateup migratedown sqcgenerate test server