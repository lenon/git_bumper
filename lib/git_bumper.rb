require 'git_bumper/version'
require 'git_bumper/strategies/semantic_version'
require 'git_bumper/strategies/build'
require 'git_bumper/utils'
require 'git_bumper/git'
require 'git_bumper/cli_parser'
require 'git_bumper/cli'

module GitBumper
  def self.run
    parser = CLIParser.new(ARGV)
    abort unless parser.parse

    cli = CLI.new(parser.options)
    cli.run

    abort cli.error_msg if cli.error?
  end
end
