require 'spec_helper'

RSpec.describe GitBumper::Git do
  use_temporary_cwd

  subject { described_class }

  describe '.repo?' do
    context 'not a git repo' do
      it 'returns false' do
        expect(subject.repo?).to be false
      end
    end

    context 'inside a git repo' do
      it 'returns true' do
        `git init test >/dev/null 2>&1`

        Dir.chdir('test') do
          expect(subject.repo?).to be true
        end
      end
    end
  end

  describe '.greatest_tag' do
    setup_basic_git_repo

    context 'clean repo' do
      it 'returns false' do
        expect(subject.greatest_tag).to be false
      end
    end

    context 'when an lightweight tag is the greatest' do
      before do
        `git tag v0.0.1 -m "foo bar"`
        `git tag v0.0.2`
      end

      it 'returns this tag' do
        expect(subject.greatest_tag.to_s).to eql('v0.0.2')
      end
    end

    context 'when an annotated tag is the greatest' do
      before do
        `git tag v0.0.1`
        `git tag v0.0.2 -m "foo bar"`
      end

      it 'returns this tag' do
        expect(subject.greatest_tag.to_s).to eql('v0.0.2')
      end
    end

    context 'when the chronological order is not respected' do
      before do
        `git tag v0.0.1`
        `git tag v0.0.3`
        `git tag v0.0.4`
        `git tag v0.0.2`
      end

      it 'returns the greatest version' do
        expect(subject.greatest_tag.to_s).to eql('v0.0.4')
      end
    end

    context 'with a custom prefix' do
      before do
        `git tag a0.0.1`
        `git tag b0.0.1`
        `git tag b0.0.2`
        `git tag c0.0.3`
      end

      it 'returns the greatest version with the prefix' do
        expect(subject.greatest_tag(prefix: 'b').to_s).to eql('b0.0.2')
      end
    end

    context 'with no tags for a prefix' do
      before do
        `git tag b0.0.1`
        `git tag b0.0.2`
      end

      it 'return false' do
        expect(subject.greatest_tag).to be false
      end
    end

    context 'when a tag has not a correct version format' do
      before do
        `git tag v0.0.1`
        `git tag v0.0.2`
        `git tag v0Foobar`
      end

      it 'ignores that tag' do
        expect(subject.greatest_tag.to_s).to eql('v0.0.2')
      end
    end

    context 'build tags' do
      context 'when the chronological order is not respected' do
        before do
          `git tag v1`
          `git tag v3`
          `git tag v4`
          `git tag v2`
        end

        it 'returns the greatest version' do
          tag = subject.greatest_tag(klass: GitBumper::BuildTag)
          expect(tag.to_s).to eql('v4')
        end
      end

      context 'with a custom prefix' do
        before do
          `git tag a1`
          `git tag b1`
          `git tag b2`
          `git tag c3`
        end

        it 'returns the greatest version with the prefix' do
          tag = subject.greatest_tag(prefix: 'b',
                                     klass: GitBumper::BuildTag)
          expect(tag.to_s).to eql('b2')
        end
      end
    end
  end

  describe '#create_tag' do
    setup_basic_git_repo

    it 'creates a new git tag' do
      subject.create_tag(GitBumper::Tag.new('v', 0, 0, 1))
      expect(`git tag`.strip).to eql('v0.0.1')
    end
  end

  describe '#push_tag' do
    it 'pushes the tag to origin' do
      expect_any_instance_of(Kernel)
        .to receive(:`)
        .with('git push origin v0.0.1')
      subject.push_tag(GitBumper::Tag.new('v', 0, 0, 1))
    end
  end
end
