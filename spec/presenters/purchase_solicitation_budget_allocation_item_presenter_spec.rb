# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/purchase_solicitation_budget_allocation_item_presenter'

describe PurchaseSolicitationBudgetAllocationItemPresenter do
  subject do
    described_class.new(purchase_solicitation_budget_allocation_item, nil, helper)
  end

  let :purchase_solicitation_budget_allocation_item do
    double(:estimated_total_price => 300.0)
  end

  let(:helper) { double }

  it 'should return estimated total price with precision' do
    helper.should_receive(:number_with_precision).with(300).and_return("300,00")

    subject.estimated_total_price.should eq '300,00'
  end
end
