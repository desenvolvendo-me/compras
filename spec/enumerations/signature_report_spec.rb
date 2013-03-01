# encoding: utf-8
require 'enumeration_helper'
require 'app/enumerations/signature_report'

describe SignatureReport do
  it 'should return availables' do
    described_class.stub(:unavailables_keys).and_return(['supply_authorizations'])
    expect(described_class.availables).to eq [
      ["Certificados de Registro Cadastral", "registration_cadastral_certificates"],
      ["Homologações e Adjudicações de Processos Licitatórios", "licitation_process_ratifications"]
    ]
  end

  it 'should return availables_keys' do
    described_class.stub(:unavailables_keys).and_return(['supply_authorizations'])
    expect(described_class.availables_keys).to eq [
      'licitation_process_ratifications',
      'registration_cadastral_certificates'
    ]
  end

  it 'should return formatted reports' do
    expect(described_class.to_a_by_keys(['supply_authorizations'])).to  eq [
        ["Autorizações de Fornecimento", "supply_authorizations"]
    ]
  end
end
