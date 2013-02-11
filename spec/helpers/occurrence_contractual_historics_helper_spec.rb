# encoding: utf-8
require 'spec_helper'

describe OccurrenceContractualHistoricsHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :contract => '1', :to_s => '10') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq "Editar Ocorrência Contratual 10 do Contrato 1"
    end
  end

  describe '#new_title' do
    let(:resource) { double(:resource, :contract => '1/2013') }

    it 'should return the title for new' do
      helper.stub(:resource => resource)

      expect(helper.new_title).to eq 'Criar nova ocorrência para o contrato 1/2013'
    end
  end
end
