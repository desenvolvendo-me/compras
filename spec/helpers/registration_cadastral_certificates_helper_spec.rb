# encoding: utf-8
require 'spec_helper'

describe RegistrationCadastralCertificatesHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :creditor => 'Gabriel Sobrinho', :to_s => '10') }

    it 'should return the title for edit' do
      helper.stub(:singular => 'Certificado de Registro Cadastral')
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Editar Certificado de Registro Cadastral 10 do Credor Gabriel Sobrinho'
    end
  end
end
