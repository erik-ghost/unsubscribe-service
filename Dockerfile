# Base image: Node
FROM node:20

# Set /app directory as destination
WORKDIR /app

# Copy package.json and package-lock.json (if available) first to optimize layer caching
COPY package.json package-lock.json* /app/

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . /app/

# Add `/app/node_modules/.bin` to $PATH
ENV PATH=/app/node_modules/.bin:$PATH

# Expose port 3000 for the application server
EXPOSE 3000

# Use SIGTERM as stop signal for graceful shutdown
STOPSIGNAL SIGTERM

# Start the Express server directly with node (CommonJS)
CMD ["node", "src/main.ts"]
