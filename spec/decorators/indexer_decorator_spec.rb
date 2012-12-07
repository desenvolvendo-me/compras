require 'decorator_helper'
require 'app/decorators/indexer_decorator'

describe IndexerDecorator do
  context '#summary' do
    before do
      component.stub(:currency).and_return('Real')
    end

    it 'uses currency' do
      expect(subject.summary).to eq 'Real'
    end
  end

  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name and currency' do
      expect(described_class.header_attributes).to include :name
      expect(described_class.header_attributes).to include :currency
    end
  end
end
