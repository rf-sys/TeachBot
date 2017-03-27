FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

WORKDIR /usr/src/app

COPY Gemfile* ./

RUN bundle install

COPY . .

#install phantomjs (otherwise docker container don't see and install it after each command)
RUN sh docker/install_phantomjs.sh

EXPOSE 3000

CMD rm -rf tmp/pids/server.pid \
    && rails server -b 0.0.0.0 -p 3000