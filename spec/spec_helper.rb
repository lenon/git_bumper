require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'git_bumper'
require 'tmpdir'

module GitSetupHelpers
  def use_temporary_cwd
    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          example.run
        end
      end
    end
  end

  def setup_basic_git_repo
    around do |example|
      `git init test`

      Dir.chdir('test') do
        `git config user.email "test@example.com"`
        `git config user.name "test user"`
        `touch a.txt`
        `git add a.txt`
        `git commit -m foo`

        example.run
      end
    end
  end
end

RSpec.configure do |config|
  config.extend GitSetupHelpers
end
