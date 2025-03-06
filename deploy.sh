#!/usr/bin/env 
# -S guix shell pnpm node awscli@1 -- bash

# Assets
# bash build.sh

# Prompt the user which folder to upload
FOLDER_NAME=".site"
AWS_BUCKET_URL="s3://wiki.pantherx.org"
PROFILE_NAME="pantherx-wiki"
CLOUDFRONT_ID="E38F5RE2KPRRHH"

guix shell node pnpm graphicsmagick imagemagick ruby@2 bundler make gcc-toolchain@12 libxml2 libxslt pkg-config libsass ruby-sassc -- sh -c "BUNDLE_PATH=.bundler bundle exec jekyll build --config _config.yml -d $FOLDER_NAME" || exit 1

echo "Using AWS profile: $PROFILE_NAME"
echo "Uploading folder: $FOLDER_NAME"
echo "Destination: $AWS_BUCKET_URL"

# Upload the folder to S3 using AWS CLI
guix shell awscli -- aws s3 sync $FOLDER_NAME $AWS_BUCKET_URL --profile $PROFILE_NAME

# Invalidate CloudFront (Uncomment if you need this)
guix shell awscli -- aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_ID --paths "/*" --profile $PROFILE_NAME
