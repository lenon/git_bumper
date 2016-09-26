require 'spec_helper'

RSpec.describe GitBumper::CLIParser do
  describe 'default behavior' do
    it 'sets default options' do
      parser = described_class.new([])
      parser.parse

      expect(parser.options).to eql({
        increment: :patch,
        strategy: GitBumper::Strategies::SemanticVersion,
        prefix: 'v',
        help: false
      })
    end
  end

  context 'passing --build' do
    it 'changes the tag class to build tag' do
      parser = described_class.new(['--build'])
      parser.parse

      expect(parser.options).to eql({
        increment: :patch,
        strategy: GitBumper::Strategies::Build,
        prefix: 'v',
        help: false
      })
    end
  end

  context 'passing --prefix' do
    it 'changes the prefix' do
      parser = described_class.new(['--prefix=abc'])
      parser.parse

      expect(parser.options).to eql({
        increment: :patch,
        strategy: GitBumper::Strategies::SemanticVersion,
        prefix: 'abc',
        help: false
      })
    end
  end

  context 'passing --major' do
    it 'changes the increment option' do
      parser = described_class.new(['--major'])
      parser.parse

      expect(parser.options).to eql({
        increment: :major,
        strategy: GitBumper::Strategies::SemanticVersion,
        prefix: 'v',
        help: false
      })
    end
  end

  context 'passing --minor' do
    it 'changes the increment option' do
      parser = described_class.new(['--minor'])
      parser.parse

      expect(parser.options).to eql({
        increment: :minor,
        strategy: GitBumper::Strategies::SemanticVersion,
        prefix: 'v',
        help: false
      })
    end
  end

  context 'passing --help' do
    it 'sets help option to true' do
      parser = described_class.new(['--help'])
      parser.parse

      expect(parser.options.fetch(:help)).to be true
    end
  end
end
