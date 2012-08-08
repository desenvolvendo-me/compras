require 'decorator_helper'
require 'app/decorators/licitation_process_lot_decorator'

describe LicitationProcessLotDecorator do
  context '#winner_proposal_total_price' do
    context 'when do not have winner_proposal_total_price' do
      before do
        component.stub(:winner_proposal_total_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.winner_proposal_total_price).to be_nil
      end
    end

    context 'when have winner_proposal_total_price' do
      before do
        component.stub(:winner_proposal_total_price).and_return(9.99)
      end

      it 'should applies currency' do
        expect(subject.winner_proposal_total_price).to eq 'R$ 9,99'
      end
    end
  end
end
