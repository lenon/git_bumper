require 'spec_helper'

RSpec.describe GitBumper::BuildTag do
  describe '.parse' do
    subject { described_class }

    context 'passing an invalid tag' do
      it 'returns false' do
        %w(abcd v0.0.1 1234 0.0.0 v0.0).each do |invalid_tag|
          expect(subject.parse(invalid_tag)).to be false
        end
      end
    end

    context 'passing a valid tag' do
      it 'returns a tag object' do
        %w(v0 v123).each do |valid_tag|
          tag = subject.parse(valid_tag)

          expect(tag).to be_kind_of(GitBumper::BuildTag)
          expect(tag.to_s).to eql(valid_tag)
        end
      end

      it 'converts build number to integer' do
        tag = subject.parse('v1')

        expect(tag.build).to be 1
      end
    end
  end

  subject { described_class.new('v', 0) }

  it { is_expected.to respond_to(:prefix) }
  it { is_expected.to respond_to(:build) }
  it { is_expected.to respond_to(:build=) }
end
