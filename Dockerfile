# Base image: Node
FROM node:20

# Set /app directory as destination
WORKDIR /app

# Update App
ADD . /app/

# Install dependencies
RUN npm install

# Add `/app/node_modules/.bin` to $PATH
ENV PATH=/app/node_modules/.bin:$PATH

# Expose port 5173 for Vite dev server
EXPOSE 5173

# Start the app
CMD ["npm", "run", "dev"]
