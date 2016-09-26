require 'optparse'
require 'ostruct'

module GitBumper
  # This is the parser for CLI arguments.
  class CLIParser
    attr_reader :options

    # @param argv [Array<String>]
    def initialize(argv)
      @argv = argv
      @parser = OptionParser.new
      @options = {
        strategy: Strategies::SemanticVersion,
        prefix: 'v',
        increment: :patch,
        help: false
      }
    end

    def parse
      @parser.banner = 'Usage: git bump [options]'

      @parser
        .on('-b', '--build', 'Use build tags') do
          @options[:strategy] = Strategies::Build
        end
        .on('-p', '--prefix [PREFIX]', 'Set a prefix') do |prefix|
          @options[:prefix] = prefix
        end
        .on('--major', 'Increments the major version') do
          @options[:increment] = :major
        end
        .on('--minor', 'Increments the minor version') do
          @options[:increment] = :minor
        end
        .on('-h', '--help', 'Prints this help') do
          @options[:help] = true
        end

      @parser.parse!(@argv)
    end
  end
end
