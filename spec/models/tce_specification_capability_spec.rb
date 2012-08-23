# encoding: utf-8
require 'model_helper'
require 'app/models/tce_specification_capability'

describe TceSpecificationCapability do
  it 'should return description as to_s' do
    subject.description = 'Ampliação Posto de Saúde'
    expect(subject.to_s).to eq 'Ampliação Posto de Saúde'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :capability_source }
  it { should validate_presence_of :application_code }

  it { should belong_to :capability_source }
  it { should belong_to :application_code }
  it { should have_many(:capabilities).dependent(:restrict) }
end
