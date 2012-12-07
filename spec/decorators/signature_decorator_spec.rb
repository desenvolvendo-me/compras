require 'decorator_helper'
require 'app/decorators/signature_decorator'

describe SignatureDecorator do
  context '#summary' do
    before do
      component.stub(:position).and_return(position)
    end

    let :position do
      double('Position', :to_s => 'Gerente')
    end

    it 'should return position as summary' do
      expect(subject.summary).to eq 'Gerente'
    end
  end

  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have person and position' do
      expect(described_class.header_attributes).to include :person
      expect(described_class.header_attributes).to include :position
    end
  end
end
