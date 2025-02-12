# Base image
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile

# Copy application code
COPY . .

# Build the Next.js app
RUN npm run build

# Use a minimal base image for running the app
FROM node:20-alpine AS runner

# Set working directory
WORKDIR /app

# Copy built assets from builder stage
COPY --from=builder /app/.next .next
COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/public public
COPY --from=builder /app/package.json package.json

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose port
EXPOSE 3000

# Start the Next.js app
CMD ["node", "node_modules/.bin/next", "start"]
