require 'decorator_helper'
require 'app/decorators/bidder_decorator'

describe BidderDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have creditor and status' do
      expect(described_class.header_attributes).to include :creditor, :enabled
    end
  end

  context '#process_date' do
    context 'when do not have licitation_process_process_date' do
      before do
        component.stub(:licitation_process_process_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.process_date).to be_nil
      end
    end

    context 'when have licitation_process_process_date' do
      before do
        component.stub(:licitation_process_process_date).and_return(Date.new(2012, 12, 1))
      end

      it 'should localize' do
        expect(subject.process_date).to eq '01/12/2012'
      end
    end
  end

  describe "#proposal_total_value_by_lot" do
    context 'when do not have proposal_total_value_by_lot' do
      before do
        component.stub(:proposal_total_value_by_lot).and_return(0)
      end

      it 'should applies precision to zero' do
        expect(subject.proposal_total_value_by_lot).to eq '0,00'
      end
    end

    context 'when have proposal_total_value_by_lot' do
      before do
        component.stub(:proposal_total_value_by_lot).with(lot).and_return(5000.0)
      end

      let :lot do
        double :lot
      end

      it 'should applies precision' do
        expect(subject.proposal_total_value_by_lot(lot)).to eq '5.000,00'
      end
    end
  end

  context '#proposal_total_value' do
    context 'when do not have proposal_total_value' do
      before do
        component.stub(:proposal_total_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.proposal_total_value).to be_nil
      end
    end

    context 'when have proposal_total_value' do
      before do
        component.stub(:proposal_total_value).and_return(10.0)
      end

      it 'should applies precision' do
        expect(subject.proposal_total_value).to eq '10,00'
      end
    end
  end

  describe '#cant_save_or_destroy_message' do
    before do
      I18n.backend.store_translations 'pt-BR', :bidder => {
          :messages => {
            :cant_be_changed_when_licitation_process_has_a_ratification => 'ratification'
        }
      }
    end

    it 'should return the ratification message when licitation process has ratification' do
      component.stub(:licitation_process_ratification?).and_return(true)

      expect(subject.cant_save_or_destroy_message).to eq 'ratification'
    end
  end

  describe '#cant_save_or_destroy_message' do
    before do
      I18n.backend.store_translations 'pt-BR', :true =>'sim', :false => 'não'
    end

    it 'when bidders are not benefited' do
      component.stub(:benefited => false)

      expect(subject.benefited).to eq 'não'
    end

    it 'when bidders are benefited' do
      component.stub(:benefited => true)

      expect(subject.benefited).to eq 'sim'
    end
  end
end
