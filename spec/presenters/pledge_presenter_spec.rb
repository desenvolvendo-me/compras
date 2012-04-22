# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/pledge_presenter'

describe PledgePresenter do
  subject do
    described_class.new(pledge, nil, helpers)
  end

  let :pledge do
    double(:budget_allocation_real_amount => 500.0, :reserve_fund_value => 300.0)
  end

  let(:helpers) do
    double.tap do |helpers|
      helpers.stub(:number_with_precision).with(500.0).and_return("500,00")
      helpers.stub(:number_with_precision).with(300.0).and_return("300,00")
    end
  end

  it 'should return budget_allocation_real_amount with precision' do
    subject.budget_allocation_real_amount.should eq '500,00'
  end

  it 'should return reserve_fund_value with precision' do
    subject.reserve_fund_value.should eq '300,00'
  end
end
