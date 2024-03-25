#Build stage
FROM golang:alpine AS build-env
ENV GOOS linux
ENV GOARCH amd64
WORKDIR /src
COPY main.go .
RUN GO111MODULE=off CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build -a -o server

# Final
FROM ubuntu
COPY --from=build-env /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build-env /src/server .
ENV PORT 8080
CMD ["./server"]
