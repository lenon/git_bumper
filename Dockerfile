FROM ruby:latest
ADD . /code
WORKDIR /code
RUN bundle install
CMD bundle exec rspec
