module GitBumper
  # This class receives an array of arguments, parsers it and executes the
  # requested action.
  class CLI
    include Git
    include Utils

    # @param [Hash]
    def initialize(args)
      @parser = CLIParser.new(args)
      @parser.parse
      @options = @parser.options
    end

    def run
      if @options.fetch(:help)
        return print_help
      end

      bump_version
    end

    private

    def print_help
      puts @parser
    end

    def bump_version
      fetch_tags
      old_tag = greatest_tag({
        strategy: @options.fetch(:strategy),
        prefix: @options.fetch(:prefix)
      })

      unless old_tag
        abort('No tags found')
      end

      new_tag = old_tag.clone
      new_tag.increment(@options.fetch(:increment))

      puts "The old tag is      #{old_tag}"
      puts "The new tag will be #{new_tag}"
      puts 'Push to origin? (Y/n)'

      unless confirm_action?
        abort('Aborted')
      end

      create_tag(new_tag)
      push_tag(new_tag)
    end
  end
end
