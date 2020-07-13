require 'model_helper'
require 'app/models/contract_type'

describe ContractType do
  it 'should return description as to_s method' do
    subject.description = 'Contratação de estagiários'
    expect(subject.to_s).to eq 'Contratação de estagiários'
  end

  xit { should have_many(:contracts).dependent(:restrict) }

  it { should validate_presence_of :description }
  it { should validate_presence_of :tce_code }
  it { should validate_presence_of :service_goal }
end
