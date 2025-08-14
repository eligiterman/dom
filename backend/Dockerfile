# Multi-stage Dockerfile for development and production

# Base stage with common dependencies
FROM ruby:3.4-alpine AS base

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs \
    curl \
    bash \
    && rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Development stage
FROM base AS development

# Install development dependencies
RUN bundle config set --local without '' && \
    bundle install --jobs 4 --retry 3

# Copy the rest of the application
COPY . .

# Create a non-root user
RUN addgroup -g 1000 appuser && \
    adduser -D -s /bin/bash -u 1000 -G appuser appuser && \
    chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 4000

# Set environment variables
ENV RAILS_ENV=development
ENV RACK_ENV=development

# Start the application
CMD ["bundle", "exec", "ruby", "app.rb"]

# Production stage
FROM base AS production

# Copy the rest of the application
COPY . .

# Create a non-root user
RUN addgroup -g 1000 appuser && \
    adduser -D -s /bin/bash -u 1000 -G appuser appuser && \
    chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 4000

# Set environment variables
ENV RAILS_ENV=production
ENV RACK_ENV=production

# Start the application
CMD ["bundle", "exec", "ruby", "app.rb"]

