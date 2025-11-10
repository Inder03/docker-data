# -----------------------------------------
# Stage 1: Build Angular app
# -----------------------------------------
FROM node:18-alpine AS build

# Set working directory inside container
WORKDIR /app

# Copy package.json and package-lock.json (if present)
COPY package*.json ./

# Install dependencies
RUN npm install -f

# Copy the rest of your app source code
COPY . .

# Build your Angular project
RUN npm run release


# -----------------------------------------
# Stage 2: Serve using Nginx
# -----------------------------------------
FROM nginx:alpine

# Set working directory to where Nginx serves files
WORKDIR /usr/share/nginx/html

# Remove default Nginx files
RUN rm -rf ./*

#opy the built Angular output from Stage 1
#Adjust this path if your build output folder has a different name (like /dist)
COPY --from=build /app/dist/ ./

# Optional: if using Angular routing (SPA)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose default HTTP port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
