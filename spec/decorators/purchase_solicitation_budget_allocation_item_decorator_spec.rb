# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_solicitation_budget_allocation_item_decorator'

describe PurchaseSolicitationBudgetAllocationItemDecorator do
  it 'should return estimated total price with precision' do
    component.stub(:estimated_total_price).and_return(300.0)
    helpers.should_receive(:number_with_precision).with(300).and_return("300,00")

    subject.estimated_total_price.should eq '300,00'
  end
end
