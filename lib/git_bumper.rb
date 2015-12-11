require 'git_bumper/version'
require 'git_bumper/tag'

module GitBumper
  module_function

  def git_repo?
    system('git rev-parse --is-inside-work-tree >/dev/null 2>&1')
  end
end
