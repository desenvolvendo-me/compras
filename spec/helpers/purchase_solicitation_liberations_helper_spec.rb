# encoding: utf-8
require 'spec_helper'

describe PurchaseSolicitationLiberationsHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :purchase_solicitation => '1/2013', :to_s => '5') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Editar Liberação 5 da Solicitação de Compra 1/2013'
    end
  end

  describe '#new_title' do
    let(:parent) { double(:parent, :to_s => '1/2013') }

    it 'should return the title for new' do
      expect(helper.new_title(parent)).to eq 'Criar Liberação para a Solicitação de Compra 1/2013'
    end
  end
end
