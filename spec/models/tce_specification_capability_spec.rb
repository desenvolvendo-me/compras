# encoding: utf-8
require 'model_helper'
require 'app/models/tce_specification_capability'
require 'app/models/tce_capability_agreement'

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

  it { should have_many(:tce_capability_agreements).dependent(:destroy) }
  it { should have_many(:agreements).dependent(:restrict).through(:tce_capability_agreements) }

  describe 'validates if has inactive agreement' do
    it 'should be invalid' do
      subject.stub(:agreements => [double(:status => 'inactive'), double(:status => 'active')])

      subject.valid?

      expect(subject.errors[:agreements]).to include 'Não deve haver nenhum convênio inativo'
    end

    it 'should be valid' do
      subject.stub(:agreements => [double(:status => 'active'), double(:status => 'active')])

      subject.valid?

      expect(subject.errors[:agreements]).to be_empty
    end
  end
end
