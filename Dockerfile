FROM ruby:latest

COPY lib/git_bumper/version.rb /code/lib/git_bumper/version.rb
COPY Gemfile /code/Gemfile
COPY git_bumper.gemspec /code/git_bumper.gemspec

WORKDIR /code

RUN gem install bundler
RUN bundle install

COPY . /code
