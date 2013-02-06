require 'unit_helper'
require 'app/business/trading_item_preemptive_right'

describe TradingItemPreemptiveRight do
  describe '.bidders' do
    let(:trading_item) { double(:trading_item) }
    let(:preemptive_right_instance) { double(:preemptive_right_instance) }

    it 'should instantiate the class and call bidders_benefited' do
      described_class.should_receive(:new).with(trading_item).and_return(preemptive_right_instance)
      preemptive_right_instance.should_receive(:bidders_benefited)

      described_class.bidders(trading_item)
    end
  end
end
