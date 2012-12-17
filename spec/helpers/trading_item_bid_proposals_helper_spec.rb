# encoding: utf-8
require 'spec_helper'

describe TradingItemBidProposalsHelper do
  before do
    helper.stub(:resource).and_return(resource)
  end

  let(:resource) { double(:resource) }

  describe 'back_link_path' do
    let(:trading_item) { double(:parent, :id => 1, :trading_id => 3, :to_param => "1") }

    it 'should return the trading_item index path when not persisted' do
      resource.stub(:persisted?).and_return(false)

      expect(helper.back_link_path(trading_item)).to eq '/trading_items?trading_id=3'
    end

    it 'should return the trading_item proposal_report path when not persisted' do
      resource.stub(:persisted?).and_return(true)

      expect(helper.back_link_path(trading_item)).to eq '/trading_items/1/proposal_report'
    end
  end
end
