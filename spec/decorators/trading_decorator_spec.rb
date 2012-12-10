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

  describe 'attr_header' do
    it 'should have header' do
      expect(described_class.headers?).to be_true
    end

    it 'should have created_at' do
      expect(described_class.header_attributes).to include :created_at
    end

    it 'should have licitation_process' do
      expect(described_class.header_attributes).to include :licitation_process
    end

    it 'should have licitating_unit' do
      expect(described_class.header_attributes).to include :licitating_unit
    end

    it 'should have administrative_process_summarized_object' do
      expect(described_class.header_attributes).to include :administrative_process_summarized_object
    end

    it 'should show to_s as edit' do
      expect(described_class.to_s?).to be_true
    end
  end

  describe '#created_at' do
    it 'should return date time converted to date' do
      component.stub(:created_at).and_return(DateTime.new(2012, 12, 21, 21, 21))

      expect(subject.created_at).to eq Date.new(2012, 12, 21)
    end
  end
end
