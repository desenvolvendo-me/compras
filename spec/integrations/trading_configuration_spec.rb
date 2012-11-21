require 'spec_helper'

describe TradingConfiguration do
  describe '#percentage_limit_to_participate_in_bids' do
    context 'when have not a register' do
      it 'should return 0' do
        expect(TradingConfiguration.percentage_limit_to_participate_in_bids).to eq 0.0
      end
    end

    context 'when have a register' do
      before do
        TradingConfiguration.make!(:pregao)
      end

      it 'should return the last percentage limit to participate in bids' do
        expect(TradingConfiguration.percentage_limit_to_participate_in_bids).to eq 10.00
      end
    end
  end
end
