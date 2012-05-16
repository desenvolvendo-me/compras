require 'decorator_helper'
require 'app/decorators/administrative_process_budget_allocation_item_decorator'

describe AdministrativeProcessBudgetAllocationItemDecorator do
  it 'should return formatted winner_proposal_total_price' do
    component.stub(:winner_proposal_total_price).and_return(9.99)
    helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')

    subject.winner_proposal_total_price.should eq 'R$ 9,99'
  end
end
