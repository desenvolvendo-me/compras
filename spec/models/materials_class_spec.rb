# encoding: utf-8
require 'model_helper'
require 'app/models/materials_class'
require 'app/models/material'

describe MaterialsClass do
  it { should have_many(:materials).dependent(:restrict) }

  it { should validate_presence_of :masked_number }
  it { should validate_presence_of :description }
  it { should validate_numericality_of :number }

  it 'should return class_number and description as to_s method' do
    subject.masked_number = '30.52.10.000.000'
    subject.description = 'Hortifrutigranjeiros'

    expect(subject.to_s).to eq '30.52.10.000.000 - Hortifrutigranjeiros'
  end

  describe 'create the masked number on validate' do
    context 'when have parent_number and number' do
      it 'should make mask_number using full_number and mask_size' do
        subject.masked_number = '1.11.111.000'
        subject.parent_number = '1.23'
        subject.number = '456'
        subject.mask = '9.99.999.000'
        subject.valid?

        expect(subject.masked_number).to eq '1.23.456.000'
      end
    end

    context 'without parent_number' do
      it 'should use mask_number value' do
        subject.masked_number = '1.11.111.000'
        subject.number = '456'
        subject.mask = '9.99.999.000'
        subject.valid?

        expect(subject.masked_number).to eq '1.11.111.000'
      end
    end

    context 'without number' do
      it 'should use class_number value' do
        subject.masked_number = '1.11.111.000'
        subject.parent_number = '1.23'
        subject.mask = '9.99.999.000'
        subject.valid?

        expect(subject.masked_number).to eq '1.11.111.000'
      end
    end
  end

  describe 'fill class_number on save' do
    it 'should fills the class_number removing dots from masked_number' do
      subject.mask = '9.99.999.000'
      subject.masked_number = '1.23.560.000'

      subject.run_callbacks(:save)

      expect(subject.class_number).to eq '123560000'
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
      subject.masked_number = '10.00.000'

      expect(subject.class_number_level).to eq 1
    end

    it 'should returns 2 when filled until second level' do
      subject.masked_number = '10.53.000'

      expect(subject.class_number_level).to eq 2
    end

    it 'should returns 2 when filled until third and last level' do
      subject.masked_number = '10.53.111'

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

      context 'when is not imported' do
        before do
          subject.imported = false
        end

        it { expect(subject).to be_editable }
      end

      context 'when is imported' do
        before do
          subject.imported = true
        end

        it { expect(subject).to_not be_editable }
      end
    end
  end

  describe 'validate parent with material' do
    let(:parent) { double(:parent) }

    context 'with parent' do
      before do
        subject.stub(:parent => parent)
      end

      it 'should be valid when parent has no materials' do
        parent.stub(:materials => [])

        subject.valid?

        expect(subject.errors[:parent_class_number]).to_not include("classe com materiais associados não podem ser base para outras classes")
      end

      it 'should not be valid when parent has materials' do
        parent.stub(:materials => ['material'])

        subject.valid?

        expect(subject.errors[:parent_class_number]).to include("classe com materiais associados não podem ser base para outras classes")
      end
    end

    context 'without parent' do
      it 'should be valid when parent has no materials' do
        subject.valid?

        expect(subject.errors[:parent_class_number]).to_not include("classe com materiais associados não podem ser base para outras classes")
      end
    end
  end

  describe 'validate when edit masked_number' do
    context 'when has materials' do
      before do
        subject.stub(:materials => ['material'])
      end

      it 'should have errors when masked_number changed' do
        subject.stub(:changed_attributes => { 'masked_number' => '10.1.11.222.000' })
        subject.stub(:validation_context).and_return(:update)

        subject.valid?

        expect(subject.errors[:number]).to include('não pode ser alterado quando houver materiais vinculados à classe')
      end

      it 'should not have errors when masked_number does not changed' do
        subject.stub(:validation_context).and_return(:update)

        subject.valid?

        expect(subject.errors[:number]).to_not include('não pode ser alterado quando houver materiais vinculados à classe')
      end
    end

    context 'when does not have materials' do
      before do
        subject.stub(:materials => [])
      end

      it 'should not have errors when masked_number changed' do
        subject.stub(:changed_attributes => { 'masked_number' => '10.1.11.222.000' })
        subject.stub(:validation_context).and_return(:update)

        subject.valid?

        expect(subject.errors[:number]).to_not include('não pode ser alterado quando houver materiais vinculados à classe')
      end

      it 'should not have errors when masked_number does not changed' do
        subject.stub(:validation_context).and_return(:update)

        subject.valid?

        expect(subject.errors[:number]).to_not include('não pode ser alterado quando houver materiais vinculados à classe')
      end
    end
  end
end
