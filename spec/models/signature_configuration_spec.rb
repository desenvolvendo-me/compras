require 'model_helper'
require 'app/models/signature_configuration'
require 'app/models/signature_configuration_item'
# require 'app/models/signature'

describe SignatureConfiguration do
  xit 'should return report_humanize as to_s' do
    subject.stub(:report_humanize).and_return('Autorizações de Fornecimento')
    expect(subject.to_s).to eq 'Autorizações de Fornecimento'
  end

  it { should have_many(:signature_configuration_items).dependent(:destroy).order(:order) }

  it { should validate_presence_of :report }

  xit { should validate_duplication_of(:order).on(:signature_configuration_items) }
  xit { should validate_duplication_of(:signature_id).on(:signature_configuration_items) }
end
