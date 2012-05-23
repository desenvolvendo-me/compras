# encoding: utf-8
require 'enumeration_helper'
require 'app/enumerations/signature_report'

describe SignatureReport do
  it 'should return availables' do
    described_class.stub(:unavailables_keys).and_return(['supply_authorizations'])
    described_class.availables.should eq [['Processos Administrativos', 'administrative_processes']]
  end

  it 'should return availables_keys' do
    described_class.stub(:unavailables_keys).and_return(['supply_authorizations'])
    described_class.availables_keys.should eq ['administrative_processes']
  end

  it 'should return formatted reports' do
    described_class.to_a_by_keys(['administrative_processes', 'supply_authorizations']).should  eq [
        ['Autorizações de Fornecimento', 'supply_authorizations'],
        ['Processos Administrativos', 'administrative_processes']
    ]
  end
end
