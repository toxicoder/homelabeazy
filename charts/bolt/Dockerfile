# Build stage
FROM node:20-alpine AS builder

# Install git and pnpm
RUN apk add --no-cache git && npm install -g pnpm@9.4.0

# Clone the repository
WORKDIR /app
RUN git clone https://github.com/stackblitz/bolt.new.git .

# Install dependencies and build the application
RUN pnpm install --frozen-lockfile && pnpm run build

# Production stage
FROM node:20-alpine

# Install serve
RUN npm install -g serve

# Set up a work directory
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/build/client ./

# Expose the port and start the server
EXPOSE 3000
CMD ["serve", "-s", ".", "-l", "3000"]
