# Use the official NGINX base image
FROM nginx:latest

# Copy your custom index.html file into the default NGINX web root directory
COPY website/index.html /usr/share/nginx/html/index.html

# Expose port 80 (optional, used for documentation)
EXPOSE 80

# The default command to run NGINX is already set in the base image, but you can override it
# CMD ["nginx", "-g", "daemon off;"] # Example of overriding the command
