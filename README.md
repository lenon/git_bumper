# GitBumper

[![Build Status][travis-badge]][travis-build]
[![Code Climate][cc-badge]][cc-details]
[![Test Coverage][cc-cov-badge]][cc-cov-details]

This gem provides a command-line utility to increment git tags.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git_bumper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_bumper

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem`
file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/lenon/git_bumper. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

[travis-badge]: https://travis-ci.org/lenon/git_bumper.svg?branch=master
[travis-build]: https://travis-ci.org/lenon/git_bumper
[cc-badge]: https://codeclimate.com/github/lenon/git_bumper/badges/gpa.svg
[cc-details]: https://codeclimate.com/github/lenon/git_bumper
[cc-cov-badge]: https://codeclimate.com/github/lenon/git_bumper/badges/coverage.svg
[cc-cov-details]: https://codeclimate.com/github/lenon/git_bumper/coverage
