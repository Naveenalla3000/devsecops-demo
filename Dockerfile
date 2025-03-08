# Build stage
FROM node:20-alpine AS build
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build the project
RUN npm run build

# Production stage
FROM nginx:1.25-alpine  
#use the latest stable Alpine-based Nginx image

# Upgrade libxml2 to fix vulnerabilities

# Copy built files from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Add nginx configuration (optional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# Run Nginx
CMD ["nginx", "-g", "daemon off;"]
