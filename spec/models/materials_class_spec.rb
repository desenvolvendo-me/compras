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

  describe '#masked_class_number' do
    context 'without mask' do
      it 'should returns an ampty string' do
        expect(subject.masked_class_number).to eq ''
      end
    end

    context 'without class_number' do
      before do
        subject.stub(:mask => '99.99.999.999')
      end

      it 'should returns an ampty string' do
        expect(subject.masked_class_number).to eq ''
      end
    end

    context 'with mask and class_number' do
      before do
        subject.stub(:mask => '99.99.999.999')
      end

      it 'should apply the mask to class_number for the first level' do
        subject.class_number = '1100000000'

        expect(subject.masked_class_number).to eq '11.00.000.000'
      end

      it 'should apply the mask to class_number for the second level' do
        subject.class_number = '1134000000'

        expect(subject.masked_class_number).to eq '11.34.000.000'
      end

      it 'should apply the mask to class_number for the third level' do
        subject.class_number = '1134111000'

        expect(subject.masked_class_number).to eq '11.34.111.000'
      end

      it 'should apply the mask to class_number for the last level' do
        subject.class_number = '1134111222'

        expect(subject.masked_class_number).to eq '11.34.111.222'
      end
    end
  end

  describe '#levels' do
    it 'should returns 1 when the mask has no dot' do
      subject.mask = '999'

      expect(subject.levels).to eq 1
    end

    it 'should returns 2 when the mask has one dot' do
      subject.mask = '99.999'

      expect(subject.levels).to eq 2
    end

    it 'should returns 3 when the mask has 2 dots' do
      subject.mask = '99.999.9'

      expect(subject.levels).to eq 3
    end
  end

  describe '#class_number_level' do
    before do
      subject.stub(:mask => '99.99.999')
    end

    it 'should returns 1 when the only filled level is the first' do
      subject.class_number = '1000000'

      expect(subject.class_number_level).to eq 1
    end

    it 'should returns 2 when filled until second level' do
      subject.class_number = '1053000'

      expect(subject.class_number_level).to eq 2
    end

    it 'should returns 2 when filled until third and last level' do
      subject.class_number = '1053111'

      expect(subject.class_number_level).to eq 3
    end
  end

  describe '#editable?' do
    context 'when not new record' do
      before do
        subject.stub(:new_record? => true)
      end

      it { expect(subject).to be_editable }
    end

    context 'when not new record' do
      before do
        subject.stub(:new_record? => false)
      end

      context 'when class_number_level greater than 2' do
        before do
          subject.stub(:class_number_level => 3)
        end

        it { expect(subject).to be_editable }
      end

      context 'when class_number_level lower than 2' do
        before do
          subject.stub(:class_number_level => 1)
        end

        it { expect(subject).to_not be_editable }
      end

      context 'when class_number_level equals 2' do
        before do
          subject.stub(:class_number_level => 2)
        end

        it { expect(subject).to_not be_editable }
      end
    end
  end
end
