module GitBumper
  # This object represents a common tag in the format
  # PREFIX.MAJOR.MINOR.PATCH (e.g. v1.0.0, v2.1.3, v0.1.0).
  # It provides some methods to parse, increment and compare tags.
  class Tag
    REGEX = /\A([a-z]+)([0-9]+)\.([0-9]+)\.([0-9]+)\z/i

    # Parses a string into a Tag object.
    #
    # @param str [String]
    # @return [Tag] or false if str has an invalid format
    def self.parse(str)
      matches = str.scan(REGEX).flatten

      return false if matches.empty?

      new(matches[0],
          matches[1].to_i,
          matches[2].to_i,
          matches[3].to_i)
    end

    attr_reader :prefix
    attr_accessor :major, :minor, :patch

    # @param prefix [String]
    # @param major [Fixnum]
    # @param minor [Fixnum]
    # @param patch [Fixnum]
    def initialize(prefix, major, minor, patch)
      @prefix = prefix
      @major = major
      @minor = minor
      @patch = patch
    end

    # @return [String]
    def to_s
      "#{prefix}#{major}.#{minor}.#{patch}"
    end

    # Increments a part of the version.
    def increment(part)
      case part
      when :major
        @major += 1
      when :minor
        @minor += 1
      when :patch
        @patch += 1
      end
    end

    def <=>(other)
      [major, minor, patch] <=> [other.major, other.minor, other.patch]
    end
  end
end
