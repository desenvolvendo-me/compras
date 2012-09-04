require 'model_helper'
require 'app/models/checking_account_structure_information'

describe CheckingAccountStructureInformation do
  it 'should return name as to_s' do
    subject.name = 'Fonte de Recursos'
    expect(subject.to_s).to eq 'Fonte de Recursos'
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :tce_code }

  it { should belong_to :capability_source }
end
