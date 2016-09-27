require 'spec_helper'

describe GitBumper::Utils do
  describe '.confirm_action?' do
    context 'empty response' do
      it 'returns true' do
        allow(STDIN).to receive(:gets) { '' }

        expect(described_class.confirm_action?).to be true
      end
    end

    context 'response is yes' do
      it 'returns true' do
        allow(STDIN).to receive(:gets) { 'yes' }

        expect(described_class.confirm_action?).to be true
      end
    end

    context 'response is no' do
      it 'returns false' do
        allow(STDIN).to receive(:gets) { 'no' }

        expect(described_class.confirm_action?).to be false
      end
    end
  end
end
