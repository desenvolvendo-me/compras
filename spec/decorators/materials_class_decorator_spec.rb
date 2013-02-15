# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/materials_class_decorator'

describe MaterialsClassDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description, class_number and mask' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :class_number
      expect(described_class.header_attributes).to include :mask
    end
  end

  describe '#parent_class_number_masked' do
    it 'should returns an empty string when there is no mask' do
      subject.stub(:mask => nil)

      expect(subject.parent_class_number_masked).to eq ''
    end

    it 'should returns an empty string when there is no class_number' do
      subject.stub(:mask => '99.99.99.999.999')
      subject.stub(:class_number => nil)

      expect(subject.parent_class_number_masked).to eq ''
    end

    it 'should returns the parent number with the mask applied' do
      subject.stub(:mask => '99.99.99.999.999')
      subject.stub(:class_number => '302500000000')

      expect(subject.parent_class_number_masked).to eq '30.25.'
    end

    it 'should returns the parent number with the mask applied when at last level' do
      subject.stub(:mask => '99.99.99.999.999')
      subject.stub(:class_number => '302533111000')

      expect(subject.parent_class_number_masked).to eq '30.25.33.111.'
    end

    it 'should returns the whole number when all levels are filled' do
      subject.stub(:mask => '99.99.99.999.999')
      subject.stub(:class_number => '302533111222')

      expect(subject.parent_class_number_masked).to eq '30.25.33.111.222'
    end
  end

  describe '#persisted_parent_mask_and_class_number' do
    it 'should return an array with the parent_class_number_masked and the class_number' do
      subject.stub(:mask => '99.99.99.999.999')
      subject.stub(:class_number => '302533000000')

      expect(subject.persisted_parent_mask_and_class_number).to eq ['30.25.', '33']
    end

    it 'should return an array with the parent_class_number_masked and the class_number when at last level' do
      subject.stub(:mask => '99.99.99.999.999')
      subject.stub(:class_number => '302533111000')

      expect(subject.persisted_parent_mask_and_class_number).to eq ['30.25.33.', '111']
    end

    it 'should return an array with the parent_class_number_masked and the class_number when all levels are filled' do
      subject.stub(:mask => '99.99.99.999.999')
      subject.stub(:class_number => '302533111222')

      expect(subject.persisted_parent_mask_and_class_number).to eq ['30.25.33.111.', '222']
    end

    context 'when mask is nil' do
      it 'should return an array with empty strings' do
        subject.stub(:mask => nil)
        subject.stub(:class_number => '302533000000')

        expect(subject.persisted_parent_mask_and_class_number).to eq ['', '']
      end
    end

    context 'when mask is nil' do
      it 'should return an array with empty strings' do
        subject.stub(:mask => '99.99.99.999.999')
        subject.stub(:class_number => nil)

        expect(subject.persisted_parent_mask_and_class_number).to eq ['', '']
      end
    end
  end

  describe '#masked_to_s' do
    it 'should return the parent number masked without last dot and the description' do
      subject.stub(:parent_class_number_masked => '01.02.')
      subject.stub(:description => 'Teste')

      expect(subject.masked_to_s).to eq '01.02 - Teste'
    end

    it 'should return the description when parent_class_number_masked is empty' do
      subject.stub(:parent_class_number_masked => '')
      subject.stub(:description => 'Teste')

      expect(subject.masked_to_s).to eq ' - Teste'
    end
  end

  describe '#persisted_masked_to_s' do
    let(:parent) { double(:parent, :description => 'Produtos alimentares') }
    let(:material_class_class) { double(:material_class_class) }

    it 'should return the parent number masked without last dot and the description' do
      subject.stub(:parent_class_number_masked => '01.02.40')
      subject.stub(:mask => '99.99.99.999.999')
      component.stub(:class => material_class_class)

      material_class_class.should_receive(:find_by_class_number).any_number_of_times.with('010200000000').and_return(parent)

      expect(subject.persisted_masked_to_s).to eq '01.02 - Produtos alimentares'
    end

    it 'should return the description when parent_class_number_masked is empty' do
      subject.stub(:parent_class_number_masked => '')
      subject.stub(:mask => '99.99.99.999.999')
      component.stub(:class => material_class_class)

      material_class_class.should_not_receive(:find_by_class_number)

      expect(subject.persisted_masked_to_s).to be_nil
    end
  end

  describe '#child_mask' do
    context 'when have mask and class_number' do
      it 'should return the mask of child' do
        subject.stub(:mask => '99.99.99.999.999')
        subject.stub(:class_number => '302500000000')

        expect(subject.child_mask).to eq '99'
      end

      it 'should return the mask of child' do
        subject.stub(:mask => '99.99.99.999.999')
        subject.stub(:class_number => '302534000000')

        expect(subject.child_mask).to eq '999'
      end

      it 'should return the mask of child when last number' do
        subject.stub(:mask => '99.99.99.999.999')
        subject.stub(:class_number => '302534111000')

        expect(subject.child_mask).to eq '999'
      end

      it 'should return an empty string of child when no child' do
        subject.stub(:mask => '99.99.99.999.999')
        subject.stub(:class_number => '302534111222')

        expect(subject.child_mask).to eq ''
      end
    end
  end
end
