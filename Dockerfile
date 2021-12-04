FROM wordpress:5.8.2-php7.4-apache


# Install system dependencies
RUN apt-get update -y && apt-get install -y \
    gnupg2  \
    lsb-release  \
    && echo "deb http://packages.cloud.google.com/apt gcsfuse-jessie main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y gcsfuse \
    && apt-get clean

# Set GCS bucket
ENV BUCKET ca-oiso-test-wp-file
# Set fallback mount directory
ENV MNT_DIR /var/www/html/wp-content
ARG host
ENV WORDPRESS_DB_HOST $host
ARG password
ENV WORDPRESS_DB_USER root
ENV WORDPRESS_DB_PASSWORD $password
ENV WORDPRESS_DB_NAME wordpress

# Copy local code to the container image.
ENV APP_HOME .
ENV PORT 8080

COPY gcsfuse_run.sh ./
COPY ports.conf /etc/apache2/ports.conf 

EXPOSE 8080

# Ensure the script is executable
RUN chmod +x ./gcsfuse_run.sh

CMD ["./entrypoint.sh"]