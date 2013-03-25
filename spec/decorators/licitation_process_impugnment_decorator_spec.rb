# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_impugnment_decorator'

describe LicitationProcessImpugnmentDecorator do
  let :date do
    Date.new(2012, 1, 4)
  end

  let :time do
    Time.new(2012, 1, 3, 10)
  end

  context '#licitation_process_envelope_delivery_date' do
    context 'when have licitation_process_envelope_delivery_date' do
      before do
        component.stub(:licitation_process_envelope_delivery_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.licitation_process_envelope_delivery_date).to be_nil
      end
    end

    context 'when have licitation_process_envelope_delivery_date' do
      before do
        component.stub(:licitation_process_envelope_delivery_date).and_return(date)
      end

      it 'should return localized licitation_process_envelope_delivery_date' do
        expect(subject.licitation_process_envelope_delivery_date).to eq '04/01/2012'
      end
    end
  end

  context '#licitation_process_envelope_delivery_time' do
    context 'when have licitation_process_envelope_delivery_time' do
      before do
        component.stub(:licitation_process_envelope_delivery_time).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.licitation_process_envelope_delivery_time).to be_nil
      end
    end

    context 'when have licitation_process_envelope_delivery_time' do
      before do
        component.stub(:licitation_process_envelope_delivery_time).and_return(time)
      end

      it 'should return localized licitation_process_envelope_delivery_time' do
        expect(subject.licitation_process_envelope_delivery_time).to eq '10:00'
      end
    end
  end

  context '#licitation_process_proposal_envelope_opening_date' do
    context 'when do not have licitation_process_proposal_envelope_opening_date' do
      before do
        component.stub(:licitation_process_proposal_envelope_opening_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.licitation_process_proposal_envelope_opening_date).to be_nil
      end
    end

    context 'when have licitation_process_proposal_envelope_opening_date' do
      before do
        component.stub(:licitation_process_proposal_envelope_opening_date).and_return(date)
      end

      it 'should return localized licitation_process_proposal_envelope_opening_date' do
        expect(subject.licitation_process_proposal_envelope_opening_date).to eq '04/01/2012'
      end
    end
  end

  context '#licitation_process_proposal_envelope_opening_time' do
    context 'when have licitation_process_proposal_envelope_opening_time' do
      before do
        component.stub(:licitation_process_proposal_envelope_opening_time).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.licitation_process_proposal_envelope_opening_time).to be_nil
      end
    end

    context 'when have licitation_process_proposal_envelope_opening_time' do
      before do
        component.stub(:licitation_process_proposal_envelope_opening_time).and_return(time)
      end

      it 'should return localized licitation_process_proposal_envelope_opening_time' do
        expect(subject.licitation_process_proposal_envelope_opening_time).to eq '10:00'
      end
    end
  end

  context '#is_not_pending_message' do
    it 'when is annulled' do
      I18n.backend.store_translations 'pt-BR', :licitation_process_impugnment => {
          :messages => {
            :is_not_pending => 'não pode'
        }
      }

      component.stub(:pending? => false)

      expect(subject.is_not_pending_message).to eq 'não pode'
    end

    it 'when is not annulled' do
      component.stub(:pending? => true)

      expect(subject.is_not_pending_message).to be_nil
    end
  end
end
