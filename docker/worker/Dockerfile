FROM ruby:2.4.1

# install node
RUN wget -qO- https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs

WORKDIR /usr/src/app

# prepare rails project/gem dependencies
COPY Gemfile* ./
RUN bundle install
COPY . .

# set docker user as owner of the files
RUN useradd -ms /bin/bash docker
RUN chown -R $USER:docker .
USER docker

CMD bundle exec sidekiq -C config/sidekiq.yml