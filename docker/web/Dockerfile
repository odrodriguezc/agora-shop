FROM ruby:3.4

# Install system dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nodejs npm postgresql-client libpq-dev build-essential \
 && rm -rf /var/lib/apt/lists/*

# Install Yarn and Bundler
RUN npm install -g yarn
RUN gem install bundler rails

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock first to leverage Docker caching
COPY Gemfile Gemfile.lock /app/

# Install gems
RUN bundle install

# Copy entrypoint script
COPY ./docker/web/docker_entrypoint.sh /usr/local/bin/docker_entrypoint
RUN chmod +x /usr/local/bin/docker_entrypoint

# Copy the rest of the application files
COPY . /app

# Expose port and set entrypoint
EXPOSE 3000
ENTRYPOINT ["docker_entrypoint"]
CMD ["bash","-c", "./bin/dev"]
# CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
