FROM golang:1.24-alpine AS builder

WORKDIR /app
COPY go.* ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app ./cmd/main.go

FROM gcr.io/distroless/static-debian12

WORKDIR /
COPY --from=builder /app/app /app
USER nonroot:nonroot
EXPOSE 8080

ENTRYPOINT ["/app"]