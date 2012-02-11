# encoding: utf-8
require 'model_helper'
require 'app/models/service_or_contract_type'
require 'app/models/material'

describe ServiceOrContractType do
  it 'should return description as to_s method' do
    subject.description = 'Contratação de estagiários'
    subject.to_s.should eq 'Contratação de estagiários'
  end

  it { should have_many(:materials).dependent(:restrict) }

  it { should validate_presence_of :description }
  it { should validate_presence_of :tce_code }
  it { should validate_presence_of :service_goal }
end
