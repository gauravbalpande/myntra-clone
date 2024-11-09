# Step 1: Build the React frontend
FROM node:16 AS build

WORKDIR /app

# Copy the package.json and package-lock.json for frontend dependencies
COPY client/package.json client/package-lock.json /app/client/

# Install frontend dependencies
RUN cd client && npm install

# Copy the rest of the React app and build it
COPY client /app/client
RUN cd client && npm run build

# Step 2: Setup the Node.js backend
FROM node:16

WORKDIR /app

# Copy the backend package.json and package-lock.json for backend dependencies
COPY server/package.json server/package-lock.json /app/server/
RUN cd server && npm install

# Copy the backend code into the container
COPY server /app/server

# Copy the built React frontend into the backend's public directory
COPY --from=build /app/client/build /app/server/public

# Expose the backend server port (adjust if necessary)
EXPOSE 5000

# Start the Node.js backend server
CMD ["npm", "start", "--prefix", "server"]
