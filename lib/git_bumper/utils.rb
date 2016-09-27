module GitBumper
  module Utils
    module_function

    def confirm_action?
      input = STDIN.gets.chomp.to_s
      input.empty? || !!input.match(/\Ay(es)?\z/i)
    end
  end
end
