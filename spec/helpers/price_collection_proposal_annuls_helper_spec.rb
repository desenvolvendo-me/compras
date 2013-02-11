# encoding: utf-8
require 'spec_helper'

describe PriceCollectionProposalAnnulsHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :creditor => 'Gabriel Sobrinho', :price_collection => '10') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Anulação da Proposta de Gabriel Sobrinho para a Coleta de Preço 10'
    end
  end

  describe '#new_title' do
    let(:resource) { double(:resource, :creditor => 'Gabriel Sobrinho', :price_collection => '10') }

    it 'should return the title for new' do
      helper.stub(:resource => resource)

      expect(helper.new_title).to eq 'Anular Proposta do Fornecedor Gabriel Sobrinho para a Coleta de Preço 10'
    end
  end
end
