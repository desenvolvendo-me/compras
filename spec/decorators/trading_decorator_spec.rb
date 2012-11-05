require 'decorator_helper'
require 'app/decorators/trading_decorator'

describe TradingDecorator do
  describe '#licitation_process_id' do
    context 'when no licitation process has been assigned' do
      before do
        component.stub(:licitation_process_id).and_return(nil)
      end

      it 'returns an invalid id' do
        expect(subject.licitation_process_id).to eq -1
      end
    end

    context 'when a licitation process has been assigned' do
      before do
        component.stub(:licitation_process_id).and_return(1)
      end

      it 'returns the id of the associated licitation process' do
        expect(subject.licitation_process_id).to eq 1
      end
    end
  end
end
