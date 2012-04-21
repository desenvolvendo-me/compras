# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_modality'
require 'app/models/pledge'
require 'app/models/reserve_fund'

describe LicitationModality do
  it { should belong_to :regulatory_act }

  it { should validate_presence_of :description }
  it { should validate_presence_of :regulatory_act }
  it { should validate_presence_of :initial_value }
  it { should validate_presence_of :final_value }
  it { should validate_numericality_of :initial_value }
  it { should validate_numericality_of :final_value }

  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:reserve_funds).dependent(:restrict) }

  it 'should have final value greater or equal to initial value' do
    subject.initial_value = 100.00

    subject.should allow_value(100.00).for(:final_value)
    subject.should allow_value(100.01).for(:final_value)
    subject.should_not allow_value(99.99).for(:final_value).with_message("não pode ser menor que o valor inicial")
  end

  it 'should return description as to_s method' do
    subject.description = 'Modalidade'

    subject.to_s.should eq 'Modalidade'
  end
end
