require 'decorator_helper'
require 'app/decorators/administrative_process_budget_allocation_item_decorator'

describe AdministrativeProcessBudgetAllocationItemDecorator do
  context '#total_price' do
    before do
      component.stub(:total_price).and_return(9.99)
      helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')
    end

    it 'should applies currency' do
      subject.total_price.should eq 'R$ 9,99'
    end
  end

  context '#winner_proposals_unit_price' do
    before do
      component.stub(:winner_proposals_unit_price).and_return(9.99)
      helpers.stub(:number_with_precision).with(9.99).and_return('9,99')
    end

    it 'should applies precision' do
      subject.winner_proposals_unit_price.should eq '9,99'
    end
  end

  context '#winner_proposals_total_price' do
    before do
      component.stub(:winner_proposals_total_price).and_return(9.99)
      helpers.stub(:number_with_precision).with(9.99).and_return('9,99')
    end

    it 'should applies precision' do
      subject.winner_proposals_total_price.should eq '9,99'
    end
  end
end
