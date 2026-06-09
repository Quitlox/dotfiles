FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /glance-extension-opencode .

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /glance-extension-opencode /glance-extension-opencode

EXPOSE 8080

ENTRYPOINT ["/glance-extension-opencode"]
