require 'spec_helper'

describe PriceCollectionAnnulsHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :price_collection => '1/2013') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Anulação da Coleta de Preço 1/2013'
    end
  end

  describe '#new_title' do
    let(:resource) { double(:resource, :price_collection => '1/2013') }

    it 'should return the title for new' do
      helper.stub(:resource => resource)

      expect(helper.new_title).to eq 'Anular Coleta de Preço 1/2013'
    end
  end
end
