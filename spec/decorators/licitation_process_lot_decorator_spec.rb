require 'decorator_helper'
require 'app/decorators/licitation_process_lot_decorator'

describe LicitationProcessLotDecorator do
  it 'should return formatted winner_proposal_total_price' do
    component.stub(:winner_proposal_total_price).and_return(9.99)
    helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')

    subject.winner_proposal_total_price.should eq 'R$ 9,99'
  end
end
