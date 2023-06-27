FROM franzos/jekyll-node-python-awscli:v0.4

WORKDIR /usr/working

COPY Gemfile ./
COPY package.json ./

EXPOSE 4000
