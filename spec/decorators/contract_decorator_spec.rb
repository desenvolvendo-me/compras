require 'decorator_helper'
require 'app/decorators/contract_decorator'

describe ContractDecorator do
  context '#all_pledges_total_value' do
    context 'when do not have all_pledges_total_value' do
      before do
        component.stub(:persisted?).and_return false
        component.stub(:all_pledges_total_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.all_pledges_total_value).to eq 'R$ 0,00'
      end
    end

    context 'when have all_pledges_total_value' do
      before do
        component.stub(:persisted?).and_return true
        component.stub(:all_pledges_total_value).and_return(100.0)
      end

      it 'should applies currency' do
        expect(subject.all_pledges_total_value).to eq 'R$ 100,00'
      end
    end
  end

  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have contract_number, year and publication_date' do
      expect(described_class.header_attributes).to include :contract_number
      expect(described_class.header_attributes).to include :year
      expect(described_class.header_attributes).to include :publication_date
    end
  end
end
