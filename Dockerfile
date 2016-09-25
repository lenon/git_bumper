FROM ruby:latest

COPY lib/git_bumper/version.rb /code/lib/git_bumper/
COPY Gemfile git_bumper.gemspec /code/

WORKDIR /code

RUN gem install bundler
RUN bundle install

COPY . /code
