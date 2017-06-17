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

#install phantomjs (otherwise docker container doesn't see and install it after each command)
RUN bash scripts/install_phantomjs.sh

EXPOSE 3000

CMD bash scripts/start.sh