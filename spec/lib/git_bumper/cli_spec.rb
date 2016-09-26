require 'spec_helper'

RSpec.describe GitBumper::CLI do
  let(:options) do
    {
      klass: GitBumper::Strategies::SemanticVersion,
      prefix: 'v',
      increment: :patch
    }
  end

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

          example.run
        end
      end
    end
  end

  before do
    allow(STDIN).to receive(:gets) { 'yes' } # assume yes for every prompt
  end

  context 'confirmation prompt' do
    before do
      `git tag v0.1.0`
      allow(STDIN).to receive(:gets) { input }
    end

    context 'empty input' do
      let(:input) { '' }

      it 'creates a greater tag' do
        subject = described_class.new(options)
        subject.run

        expect(`git tag`.split).to eql(%w(v0.1.0 v0.1.1))
      end
    end

    context 'input "yes"' do
      let(:input) { 'yes' }

      it 'creates a greater tag' do
        subject = described_class.new(options)
        subject.run

        expect(`git tag`.split).to eql(%w(v0.1.0 v0.1.1))
      end
    end

    context 'wrong input' do
      let(:input) { 'wrong input' }
      subject { described_class.new(options) }

      it 'sets the exit message' do
        subject.run

        expect(subject.error_msg).to eql('Aborted.')
        expect(subject.error?).to be true
      end
    end
  end

  describe 'no tag present' do
    subject { described_class.new(options) }

    it 'sets the exit message' do
      subject.run

      expect(subject.error_msg).to eql('No tags found.')
      expect(subject.error?).to be true
    end
  end

  context 'there is a tag present' do
    before do
      `git tag v0.1.0`
    end

    it 'creates a greater tag' do
      subject = described_class.new(options)
      subject.run

      expect(`git tag`.split).to eql(%w(v0.1.0 v0.1.1))
    end
  end

  context 'build tags' do
    before do
      `git tag v1`
    end

    it 'creates a greater tag' do
      subject = described_class.new(options.merge(klass: GitBumper::Strategies::Build))
      subject.run

      expect(`git tag`.split).to eql(%w(v1 v2))
    end
  end

  context 'custom prefix' do
    before do
      `git tag a1.0.0`
    end

    it 'creates a greater tag' do
      subject = described_class.new(options.merge(prefix: 'a'))
      subject.run

      expect(`git tag`.split).to eql(%w(a1.0.0 a1.0.1))
    end
  end

  context 'increments major' do
    before do
      `git tag v1.0.0`
    end

    it 'creates a greater tag' do
      subject = described_class.new(options.merge(increment: :major))
      subject.run

      expect(`git tag`.split).to eql(%w(v1.0.0 v2.0.0))
    end
  end

  context 'increments minor' do
    before do
      `git tag v1.0.0`
    end

    it 'creates a greater tag' do
      subject = described_class.new(options.merge(increment: :minor))
      subject.run

      expect(`git tag`.split).to eql(%w(v1.0.0 v1.1.0))
    end
  end
end
