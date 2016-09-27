require 'spec_helper'

RSpec.describe GitBumper::CLI do
  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        `git init test`

        Dir.chdir('test') do
          `git config user.email "test@example.com"`
          `git config user.name "test user"`
          `touch a.txt`
          `git add a.txt`
          `git commit -m foo`

          begin
            example.run
          rescue SystemExit
            # CLI can perform some Kernel#abort calls. This rescue is here
            # to make sure that specs don't exit unexpectedly.
          end
        end
      end
    end
  end

  before do
    allow(STDIN).to receive(:gets) { 'yes' } # assume yes for every prompt
  end

  context 'help menu' do
    it 'prints the help menu' do
      expect do
        described_class.new(['git-bump', '--help']).run
      end.to output(/Usage: git bump/).to_stdout
    end
  end

  describe 'no tag present' do
    it 'exits with an error' do
      expect do
        described_class.new(['git-bump']).run
      end.to raise_error(SystemExit)
    end
  end

  context 'there is a tag present' do
    before do
      `git tag v0.1.0`
    end

    it 'creates a greater tag' do
      subject = described_class.new(['git-bump'])
      subject.run

      expect(`git tag`.split).to eql(%w(v0.1.0 v0.1.1))
    end
  end

  context 'build tags' do
    before do
      `git tag v1`
    end

    it 'creates a greater tag' do
      subject = described_class.new(['git-bump'])
      subject.run

      expect(`git tag`.split).to eql(%w(v1 v2))
    end
  end

  context 'custom prefix' do
    before do
      `git tag a1.0.0`
    end

    it 'creates a greater tag' do
      subject = described_class.new(['git-bump', '-p a'])
      subject.run

      expect(`git tag`.split).to eql(%w(a1.0.0 a1.0.1))
    end
  end

  context 'increments major' do
    before do
      `git tag v1.0.0`
    end

    it 'creates a greater tag' do
      subject = described_class.new(['git-bump', '--major'])
      subject.run

      expect(`git tag`.split).to eql(%w(v1.0.0 v2.0.0))
    end
  end

  context 'increments minor' do
    before do
      `git tag v1.0.0`
    end

    it 'creates a greater tag' do
      subject = described_class.new(['git-bump', '--minor'])
      subject.run

      expect(`git tag`.split).to eql(%w(v1.0.0 v1.1.0))
    end
  end
end
