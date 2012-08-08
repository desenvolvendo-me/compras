# encoding: utf-8
require 'model_helper'
require 'app/models/materials_class'
require 'app/models/material'

describe MaterialsClass do
  it { should belong_to :materials_group }
  it { should have_many(:materials).dependent(:restrict) }

  it { should validate_presence_of :class_number }
  it { should validate_numericality_of :class_number }
  it { should validate_presence_of :description }

  it { should_not allow_value('ab').for(:class_number) }
  it { should_not allow_value('123').for(:class_number) }
  it { should allow_value('01').for(:class_number) }

  it 'should return class_number and description as to_s method' do
    subject.class_number = '01'
    subject.description = 'Hortifrutigranjeiros'

    expect(subject.to_s).to eq '01 - Hortifrutigranjeiros'
  end
end
