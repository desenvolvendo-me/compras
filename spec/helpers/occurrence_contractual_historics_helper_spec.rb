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
end
