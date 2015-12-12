module GitBumper
  # This module has some functions to deal with a git repository.
  module Git
    module_function

    # Returns true if the current working directory has a git repository.
    #
    # @return [Boolean]
    def repo?
      system('git rev-parse --is-inside-work-tree >/dev/null 2>&1')
    end

    # Fetches all git tags.
    def fetch_tags
      system('git fetch --tags >/dev/null 2>&1')
    end

    # Returns the greatest tag.
    def greatest_tag(prefix: 'v', klass: Tag)
      output = `git tag --list --sort=-v:refname "#{prefix}[0-9]*" 2> /dev/null`

      tags = output.split.collect do |tag|
        klass.parse(tag)
      end

      tags.find do |tag|
        tag
      end || false
    end

    # Create a new git tag.
    def create_tag(tag)
      `git tag #{tag}`
    end

    # Pushes a tag to origin.
    def push_tag(tag)
      `git push origin #{tag}`
    end
  end
end
