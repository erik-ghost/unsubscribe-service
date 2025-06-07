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

# Expose port 3000 for the application server
EXPOSE 3000


# Start the app
CMD ["npm", "run", "dev"]
