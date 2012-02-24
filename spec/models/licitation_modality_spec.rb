# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_modality'

describe LicitationModality do
  it { should belong_to :administractive_act }

  it { should validate_presence_of :description }
  it { should validate_presence_of :administractive_act }
  it { should validate_presence_of :initial_value }
  it { should validate_presence_of :final_value }
  it { should validate_numericality_of :initial_value }
  it { should validate_numericality_of :final_value }

  it { should have_many(:pledges).dependent(:restrict) }

  it 'should have final value greater or equal to initial value' do
    subject.final_value = 100.00
    subject.initial_value = 100.00

    subject.valid?

    subject.errors.messages[:final_value].should be_nil

    subject.final_value = 100.00
    subject.initial_value = 100.01

    subject.valid?

    subject.errors.messages[:final_value].should include "não pode ser menor que o valor inicial"
  end

  it 'should return description as to_s method' do
    subject.description = 'Modalidade'

    subject.to_s.should eq 'Modalidade'
  end
end
