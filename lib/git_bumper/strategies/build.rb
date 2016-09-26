module GitBumper
  module Strategies
    # This class implements the "build" strategy. These kind of tags are
    # expected to have the format [PREFIX][BUILD_NUMBER] like "v1", "v2", etc.
    class Build
      REGEX = /\A([a-z]+)([0-9]+)\z/i

      # Parses a string.
      #
      # @param str [String]
      # @return [Build] or false if str has an invalid format
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

      def <=>(other)
        build <=> other.build
      end
    end
  end
end
