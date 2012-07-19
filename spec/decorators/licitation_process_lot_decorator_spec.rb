require 'decorator_helper'
require 'app/decorators/licitation_process_lot_decorator'

describe LicitationProcessLotDecorator do
  context '#winner_proposal_total_price' do
    before do
      component.stub(:winner_proposal_total_price).and_return(9.99)
      helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')
    end

    it 'should applies currency' do
      subject.winner_proposal_total_price.should eq 'R$ 9,99'
    end
  end
end
