# encoding: utf-8
require 'spec_helper'

describe ContractTerminationsHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :contract=> '1/2013', :to_s => '10') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Editar Rescisão 10 do Contrato 1/2013'
    end
  end
end
