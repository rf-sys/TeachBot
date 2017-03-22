FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /myapp

WORKDIR /myapp

ADD Gemfile /myapp/Gemfile

ADD Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

COPY . .

EXPOSE 3000

CMD rm -rf tmp/pids/server.pid \
    && rails server -b 0.0.0.0 -p 3000