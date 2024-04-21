# Use the same base image as in your GitLab CI
FROM timbru31/ruby-node:2.7-18

# Install the necessary dependencies
RUN apt-get update && \
    apt-get install -y build-essential default-jre graphicsmagick imagemagick dh-autoreconf openssl default-jre

# Set the working directory in the Docker image
WORKDIR /app

# Copy your application into the Docker image
COPY . /app

# Install Ruby dependencies
RUN bundle install --path vendor

# Install pnpm
RUN npm install -g pnpm

# Install Node.js dependencies using pnpm
RUN pnpm install

# Gulp
RUN pnpm exec gulp

# Build the Jekyll site
RUN bundle exec jekyll build --config _config.yml -d .site/

# The command that will be run when the Docker container starts
CMD ["bundle", "exec", "jekyll", "serve", "-d", ".site"]