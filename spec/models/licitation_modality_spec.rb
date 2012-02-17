# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_modality'

describe LicitationModality do
  it { should belong_to :administractive_act }

  it { should validate_presence_of :description }

  it 'should have initial value less than final value' do
    subject.final_value = 100.00
    subject.initial_value = 100.01

    subject.valid?

    subject.errors.messages[:initial_value].should include "deve ser menor que 100.0"
  end

  it 'should return description as to_s method' do
    subject.description = 'Modalidade'

    subject.to_s.should eq 'Modalidade'
  end
end
