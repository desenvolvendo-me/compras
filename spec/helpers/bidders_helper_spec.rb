# encoding: utf-8
require 'spec_helper'

describe BiddersHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :licitation_process => '1/2013', :to_s => 'Gabriel Sobrinho') }

    it 'should return the title for edit' do
      helper.stub(:singular => 'Licitante')
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Editar Licitante (Gabriel Sobrinho) do Processo Licitatório 1/2013'
    end
  end

  describe '#new_title' do
    let(:resource) { double(:resource, :licitation_process => '1/2013') }

    it 'should return the title for new' do
      helper.stub(:singular => 'Licitante')
      helper.stub(:resource => resource)

      expect(helper.new_title).to eq 'Criar Licitante no Processo Licitatório 1/2013'
    end
  end
end
