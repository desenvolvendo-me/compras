# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/signature_configuration_decorator'

describe SignatureConfigurationDecorator do
  context 'available keys' do
    let :signature_report_enumeration do
      double('SignatureReportEnumeration')
    end

    it 'should return all keys' do
      signature_report_enumeration.stub(:availables).and_return(
        [
          ['Autorizações de Fornecimento', 'supply_authorizations'],
          ['Processos Administrativos', 'administrative_processes']
        ]
      )

      component.stub(:report).and_return(nil)
      subject.availables(signature_report_enumeration).should eq [
        ['Autorizações de Fornecimento', 'supply_authorizations'],
        ['Processos Administrativos', 'administrative_processes']
      ]
    end

    it 'should return all keys plus current' do
      component.stub(:report).and_return('supply_authorizations')
      signature_report_enumeration.stub(:availables).and_return([['Processos Administrativos', 'administrative_processes']])
      signature_report_enumeration.should_receive(:to_a_by_keys).with('supply_authorizations').and_return(
        [['Autorizações de Fornecimento', 'supply_authorizations']]
      )
      subject.availables(signature_report_enumeration).should eq [
        ['Processos Administrativos', 'administrative_processes'],
        ['Autorizações de Fornecimento', 'supply_authorizations']
      ]
    end
  end
end
