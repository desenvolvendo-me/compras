# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/direct_purchase_presenter'

describe DirectPurchasePresenter do
  subject do
    described_class.new(direct_purchase, nil, helpers)
  end

  let :direct_purchase do
    double(:total_allocations_items_value => 512.34)
  end

  let :helpers do
    double.tap do |helpers|
      helpers.stub(:number_with_precision).with(512.34).and_return('512,34')
    end
  end

  it 'should return formatted total_allocations_items_value' do
    subject.total_allocations_items_value.should eq '512,34'
  end
end
