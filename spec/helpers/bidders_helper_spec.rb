require 'spec_helper'

describe BiddersHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :licitation_process => '1/2013', :to_s => 'Gabriel Sobrinho') }

    it 'should return the title for edit' do
      helper.stub(:singular => 'Habilitação')
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Editar Habilitação (Gabriel Sobrinho) do Processo de Compra 1/2013'
    end
  end

  describe '#new_title' do
    let(:resource) { double(:resource, :licitation_process => '1/2013') }

    it 'should return the title for new' do
      helper.stub(:singular => 'Habilitação')
      helper.stub(:resource => resource)

      expect(helper.new_title).to eq 'Criar Habilitação no Processo de Compra 1/2013'
    end
  end
end
