# encoding: UTF-8
require 'decorator_helper'
require 'app/decorators/licitation_process_lot_decorator'

describe LicitationProcessLotDecorator do
  context '#winner_proposal_total_price' do
    it 'should be nil when do not have winner_proposal_total_price' do
      component.stub(:winner_proposal_total_price).and_return(nil)

      expect(subject.winner_proposal_total_price).to be_nil
    end

    it 'should applies currency when have winner_proposal_total_price' do
      component.stub(:winner_proposal_total_price).and_return(9.99)

      expect(subject.winner_proposal_total_price).to eq 'R$ 9,99'
    end
  end

  context '#licitation_process_not_updatable_message' do
    let(:licitation_process) { double('licitation_process') }

    it 'when licitation process is not updatable' do
      I18n.backend.store_translations 'pt-BR', :licitation_process_lot => {
          :messages => {
            :licitation_process_not_updatable => 'não pode'
        }
      }

      component.stub(:licitation_process => licitation_process)
      licitation_process.stub(:updatable? => false)

      expect(subject.licitation_process_not_updatable_message).to eq 'não pode'
    end

    it 'when licitation process is updatable' do
      component.stub(:licitation_process => licitation_process)
      licitation_process.stub(:updatable? => true)

      expect(subject.licitation_process_not_updatable_message).to be_nil
    end
  end
end
