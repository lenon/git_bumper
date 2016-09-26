require 'spec_helper'

RSpec.describe GitBumper::Strategies::Build do
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

          expect(tag).to be_kind_of(described_class)
          expect(tag.to_s).to eql(valid_tag)
        end
      end

      it 'converts build number to integer' do
        tag = subject.parse('v1')

        expect(tag.build).to be 1
      end
    end
  end

  subject { described_class.new('v', 1) }

  it { is_expected.to respond_to(:prefix) }
  it { is_expected.to respond_to(:build) }
  it { is_expected.to respond_to(:build=) }

  describe '#increment' do
    it 'increments the build number' do
      expect do
        subject.increment
      end.to change { subject.to_s }.from('v1').to('v2')
    end
  end

  describe '#<=>' do
    context 'other tag is greater' do
      it 'returns -1' do
        other = described_class.new('v', 2)
        expect(subject <=> other).to be(-1)
      end
    end

    context 'other tag is equal' do
      it 'returns 0' do
        other = described_class.new('v', 1)
        expect(subject <=> other).to be(0)
      end
    end

    context 'other tag is lower' do
      it 'returns 1' do
        other = described_class.new('v', 0)
        expect(subject <=> other).to be(1)
      end
    end
  end
end
