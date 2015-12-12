require 'spec_helper'

RSpec.describe GitBumper::CLIParser do
  describe 'default behavior' do
    it 'sets default options' do
      parser = described_class.new([])
      parser.parse

      expect(parser.options).to eql(increment: :patch,
                                         klass: GitBumper::Tag,
                                         prefix: 'v')
    end
  end

  context 'passing --build' do
    it 'changes the tag class to build tag' do
      parser = described_class.new(['--build'])
      parser.parse

      expect(parser.options).to eql(increment: :patch,
                                         klass: GitBumper::BuildTag,
                                         prefix: 'v')
    end
  end

  context 'passing --prefix' do
    it 'changes the prefix' do
      parser = described_class.new(['--prefix=abc'])
      parser.parse

      expect(parser.options).to eql(increment: :patch,
                                         klass: GitBumper::Tag,
                                         prefix: 'abc')
    end
  end

  context 'passing --major' do
    it 'changes the increment option' do
      parser = described_class.new(['--major'])
      parser.parse

      expect(parser.options).to eql(increment: :major,
                                         klass: GitBumper::Tag,
                                         prefix: 'v')
    end
  end

  context 'passing --minor' do
    it 'changes the increment option' do
      parser = described_class.new(['--minor'])
      parser.parse

      expect(parser.options).to eql(increment: :minor,
                                         klass: GitBumper::Tag,
                                         prefix: 'v')
    end
  end

  context 'passing --help' do
    it 'prints the help message' do
      parser = described_class.new(['--help'])

      expect do
        begin
          parser.parse
        rescue SystemExit
        end
      end.to output(/Usage: git bump \[options\]/).to_stdout
    end
  end
end
