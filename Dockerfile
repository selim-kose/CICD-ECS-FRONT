# Description: This file is used to build the docker image for the application.
# The first stage is the build stage where the application is built using node:14.17.6 image.
FROM node:18.19.0 AS build-stage
LABEL authors="selim-kose@live.com"

# Set the working directory
WORKDIR /app
# Copy the package.json and package-lock.json
COPY package*.json ./
# Install the dependencies
RUN npm install
# Install the Angular CLI
RUN npm install -g @angular/cli
# Copy the source code
COPY . .
# Build the application
RUN npm run build --prod

# The second stage is the runtime stage where the application is run using nginx:1.21.3 image.
FROM nginx:alpine

# Copy the nginx configuration file
COPY nginx.conf /etc/nginx/default.conf

# Copy the build files to the nginx directory
COPY --from=build-stage /app/dist/dockerize-angular/browser /usr/share/nginx/html

# Expose the port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
