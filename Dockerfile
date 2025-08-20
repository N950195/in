# Use lightweight Node image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy only package files first for efficient caching
COPY package*.json ./

# Install only production dependencies
RUN npm ci


# Copy rest of the application code
COPY . .

# Build the application
RUN npm run build

# Create non-root user and group
RUN addgroup -g 1001 -S nodejs && \
    adduser -S invoice -u 1001 && \
    mkdir -p /app/uploads && \
    chown -R invoice:nodejs /app/uploads

# Use the non-root user
USER invoice

# Expose the app port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
