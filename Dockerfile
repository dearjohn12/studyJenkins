FROM golang:1.24-alpine as builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /build

COPY . .

RUN go mod tidy 
RUN go build -o app ./main.go  

EXPOSE 8181

CMD ["./app"]

FROM alpine:latest

WORKDIR /app
COPY --from=builder /build/app .
EXPOSE 8181
CMD ["./app"]
