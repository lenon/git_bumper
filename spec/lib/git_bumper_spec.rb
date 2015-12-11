require 'spec_helper'

RSpec.describe GitBumper do
  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        example.run
      end
    end
  end

  describe '.git_repo?' do
    context 'not a git repo' do
      it 'returns false' do
        expect(described_class.git_repo?).to be false
      end
    end

    context 'inside a git repo' do
      it 'returns true' do
        system('git init test >/dev/null 2>&1')

        Dir.chdir('test') do
          expect(described_class.git_repo?).to be true
        end
      end
    end
  end
end
