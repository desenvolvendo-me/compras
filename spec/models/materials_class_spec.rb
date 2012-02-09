# encoding: utf-8
require 'model_helper'
require 'app/models/materials_class'

describe MaterialsClass do
  it { should belong_to :materials_group }

  it { should validate_presence_of :class_number }
  it { should validate_numericality_of :class_number }
  it { should validate_presence_of :description }

  it 'should return class_number and description as to_s method' do
    subject.class_number = '01'
    subject.description = 'Hortifrutigranjeiros'

    subject.to_s.should eq '01 - Hortifrutigranjeiros'
  end

  it 'should validate mask on class_number' do
    subject.class_number = 'ab'
    subject.valid?
    subject.errors[:class_number].should include 'não é válido'

    subject.class_number = '01'
    subject.valid?
    subject.errors[:class_number].should_not include 'não é válido'
  end
end
