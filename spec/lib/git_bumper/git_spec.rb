require 'spec_helper'
require 'tmpdir'

RSpec.describe GitBumper::Git do
  subject { described_class }

  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        example.run
      end
    end
  end

  describe '.repo?' do
    context 'not a git repo' do
      it 'returns false' do
        expect(subject.repo?).to be false
      end
    end

    context 'inside a git repo' do
      it 'returns true' do
        system('git init test >/dev/null 2>&1')

        Dir.chdir('test') do
          expect(subject.repo?).to be true
        end
      end
    end
  end

  describe '.greatest_tag' do
    around do |example|
      %x(git init test)

      Dir.chdir('test') do
        %x(git config user.email "test@example.com")
        %x(git config user.name "test user")
        %x(touch a.txt)
        %x(git add a.txt)
        %x(git commit -m foo)

        example.run
      end
    end

    context 'clean repo' do
      it 'returns false' do
        expect(subject.greatest_tag).to be false
      end
    end

    context 'when an lightweight tag is the greatest' do
      before do
        %x(git tag v0.0.1 -m "foo bar")
        %x(git tag v0.0.2)
      end

      it 'returns this tag' do
        expect(subject.greatest_tag.to_s).to eql('v0.0.2')
      end
    end

    context 'when an annotated tag is the greatest' do
      before do
        %x(git tag v0.0.1)
        %x(git tag v0.0.2 -m "foo bar")
      end

      it 'returns this tag' do
        expect(subject.greatest_tag.to_s).to eql('v0.0.2')
      end
    end

    context 'when the chronological order is not respected' do
      before do
        %x(git tag v0.0.1)
        %x(git tag v0.0.3)
        %x(git tag v0.0.4)
        %x(git tag v0.0.2)
      end

      it 'returns the greatest version' do
        expect(subject.greatest_tag.to_s).to eql('v0.0.4')
      end
    end

    context 'with a custom prefix' do
      before do
        %x(git tag a0.0.1)
        %x(git tag b0.0.1)
        %x(git tag b0.0.2)
        %x(git tag c0.0.3)
      end

      it 'returns the greatest version with the prefix' do
        expect(subject.greatest_tag(prefix: 'b').to_s).to eql('b0.0.2')
      end
    end

    context 'with no tags for a prefix' do
      before do
        %x(git tag b0.0.1)
        %x(git tag b0.0.2)
      end

      it 'return false' do
        expect(subject.greatest_tag).to be false
      end
    end

    context 'when a tag has not a correct version format' do
      before do
        %x(git tag v0.0.1)
        %x(git tag v0.0.2)
        %x(git tag v0Foobar)
      end

      it 'ignores that tag' do
        expect(subject.greatest_tag.to_s).to eql('v0.0.2')
      end
    end

    context 'build tags' do
      context 'when the chronological order is not respected' do
        before do
          %x(git tag v1)
          %x(git tag v3)
          %x(git tag v4)
          %x(git tag v2)
        end

        it 'returns the greatest version' do
          tag = subject.greatest_tag(tag_class: GitBumper::BuildTag)
          expect(tag.to_s).to eql('v4')
        end
      end

      context 'with a custom prefix' do
        before do
          %x(git tag a1)
          %x(git tag b1)
          %x(git tag b2)
          %x(git tag c3)
        end

        it 'returns the greatest version with the prefix' do
          tag = subject.greatest_tag(prefix: 'b',
                                     tag_class: GitBumper::BuildTag)
          expect(tag.to_s).to eql('b2')
        end
      end
    end
  end
end
