# encoding: utf-8
require 'spec_helper'

describe TradingItemClosingsHelper do
  describe '#edit_title' do
    let(:trading_item) { double(:trading_item, :trading => '1/2013') }

    it 'should return the title for edit' do
      expect(helper.edit_title(trading_item)).to eq 'Encerramento do Item do Pregão 1/2013'
    end
  end
end
