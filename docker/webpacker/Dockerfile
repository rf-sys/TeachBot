FROM ruby:2.4.1

# install node
RUN wget -qO- https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn

WORKDIR /usr/src/app

# prepare rails project/gem dependencies
COPY Gemfile* ./
RUN bundle install
COPY . .

#install phantomjs (otherwise docker container does not see and install it after each command)
RUN bash scripts/install_phantomjs.sh

# set docker user as owner of the files
RUN useradd -ms /bin/bash docker
RUN chown -R $USER:docker .
USER docker

EXPOSE 8080

CMD yarn && ./bin/webpack-dev-server