# Start from the official Go image as a build stage
FROM golang:1.21 AS builder

WORKDIR /app

# Copy the Go source code and dependencies
COPY go.mod go.sum ./
RUN go mod tidy

# Copy the application source code
COPY . .

# Build the Go binary
RUN go build -o server .

# Start a new minimal image
FROM alpine:latest

WORKDIR /root/

# Copy the built Go binary from the builder stage
COPY --from=builder /app/server .

# Expose port 8080
EXPOSE 8080

# Run the application
CMD ["./server"]
