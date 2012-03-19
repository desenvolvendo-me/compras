# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/bid_opening_presenter'

describe BidOpeningPresenter do
  subject do
    described_class.new(bid_opening, nil, helpers)
  end

  let :bid_opening do
    double(:value_estimated => 500)
  end

  let :helpers do
    double.tap do |helpers|
      helpers.stub(:number_to_currency).with(500).and_return('R$ 500,00')
    end
  end

  it 'should return formatted value_estimated' do
    subject.stub(:value_estimated).and_return(500)
    subject.value_estimated.should eq 'R$ 500,00'
  end
end
