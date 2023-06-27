echo ""
echo "Make sure to create a project.config before running this."
echo ""

. ./project.config

function RUN_CONTAINER_BASH {
  docker build --network=host --tag ${CONTAINER} .
  
  docker container run --rm -v ${PWD}:/usr/working \
  -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  -e AWS_CLOUDFRONT_DISTRIBUTION_ID=${AWS_CLOUDFRONT_DISTRIBUTION_ID} \
  -e AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
  --network host \
  -it ${CONTAINER} /bin/bash
}

function BUILD_PROJECT {
  bundle install
  npm ci
  npm run build
}

function DEPLOY_PROJECT {
  BUILD_PROJECT
  # bundle install
  bundle exec jekyll build -d ../_site
  aws s3 sync ../_site/ s3://${AWS_S3_BUCKET} --delete
  aws cloudfront create-invalidation --distribution-id $AWS_CLOUDFRONT_DISTRIBUTION_ID --paths "/*"
}

function SERVE_PROJECT {
  BUILD_PROJECT
  # bundle install
  bundle exec jekyll serve --host 0.0.0.0 -d ../_site
}

function SERVE_PROJECT_DESKTOP {
  BUILD_PROJECT
  # bundle install
  bundle exec jekyll serve --config _config.yml,_config_desktop.yml --host 0.0.0.0 -d ../_site
}

while true; do
  clear
  cat << _EOF_
Welcome to Jekyll Manager v0.0.8

Please select:

1. jekyll serve (within container)
2. jekyll serve desktop (within container)
3. jekyll build & s3 sync (within container)
4. run container
0. Quit

_EOF_

  read -p "Enter selection [0-4] > "

  if [[ $REPLY =~ ^[0-5]$ ]]; then
    case $REPLY in
      1)
        SERVE_PROJECT
        break
        ;;
      2)
        SERVE_PROJECT_DESKTOP
        break
        ;;
      3)
        DEPLOY_PROJECT
        break
        ;;
      4)
        RUN_CONTAINER_BASH
        break
        ;;
      0)
        break
        ;;
    esac
  else
    echo "Invalid entry."
    sleep $DELAY
  fi
done
echo "Program terminated."