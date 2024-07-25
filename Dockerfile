# Stage 1: Build
FROM node:20-slim AS build

WORKDIR /app

COPY package*.json ./

COPY . .

RUN npm install

RUN node ace build

# Stage 2: Production
FROM node:20-alpine

WORKDIR /app

# Copy only the necessary files from the build stage
# COPY --from=build /app/node_modules /app/build/node_modules
COPY --from=build /app/build /app/build

# Copy any other necessary files (e.g., configuration)
COPY .env /app/build

WORKDIR /app/build

RUN npm install --prod

# Install only production dependencies
# RUN npm install

# Expose only the necessary port
EXPOSE 3333

# Command to run the application
CMD ["node", "bin/server.js"]
