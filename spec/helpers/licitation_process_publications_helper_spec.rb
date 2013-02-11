# encoding: utf-8
require 'spec_helper'

describe LicitationProcessPublicationsHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :licitation_process => '1/2013', :to_s => '4') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Editar Publicação 4 do Processo Licitatório 1/2013'
    end
  end

  describe '#new_title' do
    let(:resource) { double(:resource, :licitation_process => '1/2013') }

    it 'should return the title for new' do
      helper.stub(:singular => 'Publicação')
      helper.stub(:resource => resource)

      expect(helper.new_title).to eq 'Criar Publicação para o Processo Licitatório 1/2013'
    end
  end
end
