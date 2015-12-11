module GitBumper
  # This object represents a git build tag. It expects the following format of
  # tags:
  #   PREFIX.BUILD_NUMBER
  # It provides some methods to parse and increment build numbers.
  class BuildTag
    REGEX = /\A([a-z]+)([0-9]+)\z/i

    # Parses a string into a BuildTag object.
    #
    # @param str [String]
    # @return [BuildTag] or false if str has an invalid format
    def self.parse(str)
      matches = str.scan(REGEX).flatten

      return false if matches.empty?

      new(matches[0], matches[1].to_i)
    end

    attr_reader :prefix
    attr_accessor :build

    # @param prefix [String]
    # @param build [Fixnum]
    def initialize(prefix, build)
      @prefix = prefix
      @build = build
    end

    # @return [String]
    def to_s
      "#{prefix}#{build}"
    end

    # Increments the build number.
    def increment(*)
      @build += 1
    end
  end
end
