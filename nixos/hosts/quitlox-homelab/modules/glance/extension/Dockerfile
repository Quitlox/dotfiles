FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /opencode-glance-extension .

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /opencode-glance-extension /opencode-glance-extension

EXPOSE 8080

ENTRYPOINT ["/opencode-glance-extension"]