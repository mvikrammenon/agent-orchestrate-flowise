# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Install Flowise globally
RUN npm install -g flowise

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Run Flowise when the container launches
CMD ["npx", "flowise", "start"]
