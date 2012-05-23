# encoding: utf-8
require 'model_helper'
require 'app/models/signature_configuration'
require 'app/models/signature_configuration_item'

describe SignatureConfiguration do
  it 'should return report_humanize as to_s' do
    subject.stub(:report_humanize).and_return('Autorizações de Fornecimento')
    subject.to_s.should eq 'Autorizações de Fornecimento'
  end

  it { should have_many(:signature_configuration_items).dependent(:destroy).order(:order) }

  it { should validate_presence_of :report }
end
