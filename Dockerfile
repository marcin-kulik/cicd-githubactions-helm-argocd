# Use a minimal Ruby image
FROM ruby:3

# Install any dependencies (this example may not need it)
RUN apt-get update && apt-get install -y \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/* # Clean up to minimize the image size

# Set up a non-root user for better security
RUN useradd -ms /bin/bash myuser

# Switch to the new user
USER myuser

# Working directory for the app
WORKDIR /app

# Copy the ruby server script to the image
COPY ./http_server.rb /app/

# Expose the port the server runs on
EXPOSE 80

# Command to run the app
CMD ["ruby", "./http_server.rb"]
