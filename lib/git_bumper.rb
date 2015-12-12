require 'git_bumper/version'
require 'git_bumper/tag'
require 'git_bumper/build_tag'
require 'git_bumper/git'
require 'git_bumper/cli_parser'
require 'git_bumper/cli'

module GitBumper
  module_function

  def run
    parser = CLIParser.new(ARGV)
    parser.parse
    CLI.new(parser.options).run
  end
end
