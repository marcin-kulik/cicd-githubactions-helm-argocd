# Use multi-stage builds with a slim Ruby image
FROM ruby:3-slim as builder

# Install dependencies and create a non-root user
RUN apt-get update && apt-get install -y libssl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -ms /bin/bash myuser

# Set up working directory and copy server script
WORKDIR /app
COPY ./http_server.rb .

# Use an even smaller base image for the final stage
FROM ruby:3-slim

# Copy only necessary files from the builder stage
COPY --from=builder /usr/local/ /usr/local/
COPY --from=builder /app /app
COPY --from=builder /etc/passwd /etc/passwd

# Switch to the new user for better security
USER myuser

# Expose necessary ports and set the default command
EXPOSE 80
CMD ["ruby", "/app/http_server.rb"]