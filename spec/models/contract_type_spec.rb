# encoding: utf-8
require 'model_helper'
require 'app/models/contract_type'
require 'app/models/material'

describe ContractType do
  it 'should return description as to_s method' do
    subject.description = 'Contratação de estagiários'
    expect(subject.to_s).to eq 'Contratação de estagiários'
  end

  it { should have_many(:materials).dependent(:restrict) }
  it { should have_many(:contracts).dependent(:restrict) }

  it { should validate_presence_of :description }
  it { should validate_presence_of :tce_code }
  it { should validate_presence_of :service_goal }
end
