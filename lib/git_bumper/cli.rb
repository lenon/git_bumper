module GitBumper
  # This class receives a Hash of options parsed by CLIParser and executes the
  # requested action.
  class CLI
    attr_reader :error_msg

    # @param [Hash]
    def initialize(options)
      @options = options
      @error = false
      @error_msg = ''
    end

    def run
      Git.fetch_tags

      old_tag = greatest_tag
      return error('No tags found.') unless old_tag

      new_tag = old_tag.clone
      new_tag.increment(@options.fetch(:increment))

      puts "The old tag is      #{old_tag}"
      puts "The new tag will be #{new_tag}"
      puts 'Push to origin? (Y/n)'

      return error('Aborted.') unless prompt_yes

      Git.create_tag(new_tag)
      Git.push_tag(new_tag)
    end

    def error?
      @error
    end

    private

    def error(msg)
      @error = true
      @error_msg = msg
    end

    def prompt_yes
      input = STDIN.gets.chomp.to_s
      input.empty? || input =~ /\Ay(es)?\z/i
    end

    def greatest_tag
      Git.greatest_tag(strategy: @options.fetch(:strategy),
                       prefix: @options.fetch(:prefix))
    end
  end
end
