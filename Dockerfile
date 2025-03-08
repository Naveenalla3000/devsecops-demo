# Build stage
FROM node:20-alpine3.21 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine 
 # Uses the latest available Alpine version for Nginx
RUN apk update && apk upgrade --no-cache  # Ensures all packages are up-to-date

# Copy built files from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
