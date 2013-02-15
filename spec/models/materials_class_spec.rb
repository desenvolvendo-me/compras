# encoding: utf-8
require 'model_helper'
require 'app/models/materials_class'
require 'app/models/material'

describe MaterialsClass do
  it { should have_many(:materials).dependent(:restrict) }

  it { should validate_presence_of :class_number }
  it { should validate_presence_of :description }

  it 'should return class_number and description as to_s method' do
    subject.class_number = '01'
    subject.description = 'Hortifrutigranjeiros'

    expect(subject.to_s).to eq '01 - Hortifrutigranjeiros'
  end

  describe '#create_class_number' do
    context 'when have parent_number and number' do
      it 'should make class_number using full_number and mask_size' do
        subject.class_number = '111111000'
        subject.parent_number = '1234'
        subject.number = '56'
        subject.mask = '9.99.999.000'
        subject.valid?

        expect(subject.class_number).to eq '123456000'
      end
    end

    context 'without parent_number' do
      it 'should use class_number value' do
        subject.class_number = '111111000'
        subject.number = '56'
        subject.mask = '9.99.999.000'
        subject.valid?

        expect(subject.class_number).to eq '111111000'
      end
    end

    context 'without number' do
      it 'should use class_number value' do
        subject.class_number = '111111000'
        subject.parent_number = '1234'
        subject.mask = '9.99.999.000'
        subject.valid?

        expect(subject.class_number).to eq '111111000'
      end
    end
  end
end
