# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/reserve_fund_presenter'

describe ReserveFundPresenter do
  subject do
    described_class.new(reserve_fund, nil, helpers)
  end

  let :reserve_fund do
    double(:budget_allocation_amount => 5000.0)
  end

  let(:helpers) do
    double.tap do |helpers|
      helpers.stub(:number_with_precision).with(5000.0).and_return("5.000,00")
    end
  end

  it 'should return budget_allocation_amount with precision' do
    subject.budget_allocation_amount.should eq '5.000,00'
  end
end
