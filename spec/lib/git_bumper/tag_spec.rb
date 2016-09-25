require 'spec_helper'

RSpec.describe GitBumper::Tag do
  describe '.parse' do
    subject { described_class }

    context 'passing an invalid tag' do
      it 'returns false' do
        %w(abcd v0 1234 0.0.0 v0.0).each do |invalid_tag|
          expect(subject.parse(invalid_tag)).to be false
        end
      end
    end

    context 'passing a valid tag' do
      it 'returns a tag object' do
        %w(v0.0.1 v0.10.1 v10.0.0 v11.11.11).each do |valid_tag|
          tag = subject.parse(valid_tag)

          expect(tag).to be_kind_of(described_class)
          expect(tag.to_s).to eql(valid_tag)
        end
      end

      it 'converts version numbers to integer' do
        tag = subject.parse('v0.0.1')

        expect(tag.major).to be 0
        expect(tag.minor).to be 0
        expect(tag.patch).to be 1
      end
    end
  end

  subject { described_class.new('v', 0, 0, 1) }

  it { is_expected.to respond_to(:prefix) }
  it { is_expected.to respond_to(:major) }
  it { is_expected.to respond_to(:major=) }
  it { is_expected.to respond_to(:minor) }
  it { is_expected.to respond_to(:minor=) }
  it { is_expected.to respond_to(:patch) }
  it { is_expected.to respond_to(:patch=) }

  describe '#increment' do
    context 'major' do
      it 'increments the major version' do
        expect do
          subject.increment(:major)
        end.to change { subject.to_s }.from('v0.0.1').to('v1.0.0')
      end
    end

    context 'minor' do
      it 'increments the minor version' do
        expect do
          subject.increment(:minor)
        end.to change { subject.to_s }.from('v0.0.1').to('v0.1.0')
      end
    end

    context 'patch' do
      it 'increments the patch version' do
        expect do
          subject.increment(:patch)
        end.to change { subject.to_s }.from('v0.0.1').to('v0.0.2')
      end
    end
  end

  describe '#<=>' do
    context 'other tag is greater' do
      it 'returns -1' do
        other = described_class.new('v', 0, 0, 2)
        expect(subject <=> other).to be(-1)
      end
    end

    context 'other tag is equal' do
      it 'returns 0' do
        other = described_class.new('v', 0, 0, 1)
        expect(subject <=> other).to be(0)
      end
    end

    context 'other tag is lower' do
      it 'returns 1' do
        other = described_class.new('v', 0, 0, 0)
        expect(subject <=> other).to be(1)
      end
    end
  end
end
