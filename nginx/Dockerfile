# Nginx Reverse Proxy Dockerfile
FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/

# Expose ports
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
