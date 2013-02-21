# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/materials_class_decorator'

describe MaterialsClassDecorator do
  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have description and filled_masked_number_without_end_dot' do
      expect(described_class.header_attributes).to include :description
      expect(described_class.header_attributes).to include :filled_masked_number_without_end_dot
    end
  end

  describe '#masked_to_s' do
    it 'should return the parent number masked without last dot and the description' do
      subject.stub(:splitted_masked_number_filled => ['01', '02'])
      subject.stub(:description => 'Teste')

      expect(subject.masked_to_s).to eq '01.02 - Teste'
    end

    it 'should return the description when splitted_masked_number_filled is empty' do
      subject.stub(:splitted_masked_number_filled => [])
      subject.stub(:description => 'Teste')

      expect(subject.masked_to_s).to eq ' - Teste'
    end
  end

  describe '#persisted_masked_to_s' do
    let(:parent) { double(:parent, :description => 'Produtos alimentares') }

    before do
      component.stub(:parent => parent)
    end

    it 'should return the parent number masked without last dot and the description' do
      subject.stub(:masked_number => '01.02.40.000.000')
      component.stub(:splitted_masked_number_filled => ['01', '02', '40'])

      expect(subject.persisted_masked_to_s).to eq '01.02 - Produtos alimentares'
    end

    it 'should return the description when parent_class_number_masked is empty' do
      subject.stub(:masked_number => '')
      component.stub(:splitted_masked_number_filled => [])

      expect(subject.persisted_masked_to_s).to eq ' - Produtos alimentares'
    end
  end

  describe '#child_mask' do
    context 'when have mask and class_number' do
      it 'should return the mask of child' do
        component.stub(:splitted_masked_number => ['30', '25', '00', '000', '000'])
        component.stub(:class_number_level => 2)

        expect(subject.child_mask).to eq '99'
      end

      it 'should return the mask of child' do
        component.stub(:splitted_masked_number => ['30', '25', '54', '000', '000'])
        component.stub(:class_number_level => 3)

        expect(subject.child_mask).to eq '999'
      end

      it 'should return the mask of child when last number' do
        component.stub(:splitted_masked_number => ['30', '25', '54', '111', '000'])
        component.stub(:class_number_level => 4)

        expect(subject.child_mask).to eq '999'
      end

      it 'should return an empty string of child when no child' do
        component.stub(:splitted_masked_number => ['30', '25', '54', '111', '222'])
        component.stub(:class_number_level => 5)

        expect(subject.child_mask).to eq ''
      end
    end
  end

  describe '#filled_masked_number' do
    context 'without append dot' do
      it 'should returns an empty string when there is no class_number' do
        component.stub(:splitted_masked_number_filled => [])

        expect(subject.filled_masked_number).to eq ''
      end

      it 'should returns the parent number with the mask applied' do
        component.stub(:splitted_masked_number_filled => ['30', '25'])

        expect(subject.filled_masked_number).to eq '30.25'
      end

      it 'should returns the parent number with the mask applied when at last level' do
        component.stub(:splitted_masked_number_filled => ['30', '25', '33', '111'])

        expect(subject.filled_masked_number).to eq '30.25.33.111'
      end

      it 'should returns the whole number when all levels are filled' do
        component.stub(:splitted_masked_number_filled => ['30', '25', '33', '111', '222'])

        expect(subject.filled_masked_number).to eq '30.25.33.111.222'
      end
    end

    context 'appending dot' do
      it 'should returns an empty string when there is no class_number' do
        component.stub(:masked_number => '')
        component.stub(:levels => 4)
        component.stub(:class_number_level => 0)
        component.stub(:splitted_masked_number_filled => [])

        expect(subject.filled_masked_number(true)).to eq ''
      end

      it 'should returns the parent number with the mask applied' do
        component.stub(:masked_number => '30.25.00.000.000')
        component.stub(:levels => 5)
        component.stub(:class_number_level => 2)
        component.stub(:splitted_masked_number_filled => ['30', '25'])

        expect(subject.filled_masked_number(true)).to eq '30.25.'
      end

      it 'should returns the parent number with the mask applied when at last level' do
        component.stub(:masked_number => '30.25.33.111.000')
        component.stub(:levels => 5)
        component.stub(:class_number_level => 4)
        component.stub(:splitted_masked_number_filled => ['30', '25', '33', '111'])

        expect(subject.filled_masked_number(true)).to eq '30.25.33.111.'
      end

      it 'should returns the whole number when all levels are filled' do
        component.stub(:masked_number => '30.25.33.111.222')
        component.stub(:levels => 5)
        component.stub(:class_number_level => 5)
        component.stub(:splitted_masked_number_filled => ['30', '25', '33', '111', '222'])

        expect(subject.filled_masked_number(true)).to eq '30.25.33.111.222'
      end
    end
  end

  context '#persisted_parent_masked_number' do
    context 'appending dot' do
      it 'should returns an empty string on level 1' do
        component.stub(:splitted_masked_number_filled => ['20'])
        component.stub(:class_number_level => 1)

        expect(subject.persisted_parent_masked_number(true)).to eq ''
      end

      it 'should returns an empty string on level 2' do
        component.stub(:splitted_masked_number_filled => ['20', '30'])
        component.stub(:class_number_level => 2)

        expect(subject.persisted_parent_masked_number(true)).to eq '20.'
      end

      it 'should returns an empty string on level 3' do
        component.stub(:splitted_masked_number_filled => ['20', '30', '54'])
        component.stub(:class_number_level => 3)

        expect(subject.persisted_parent_masked_number(true)).to eq '20.30.'
      end

      it 'should returns an empty string on level 4' do
        component.stub(:splitted_masked_number_filled => ['20', '30', '54', '111'])
        component.stub(:class_number_level => 4)

        expect(subject.persisted_parent_masked_number(true)).to eq '20.30.54.'
      end

      it 'should returns an empty string on level 5' do
        component.stub(:splitted_masked_number_filled => ['20', '30', '54', '111', '222'])
        component.stub(:class_number_level => 5)

        expect(subject.persisted_parent_masked_number(true)).to eq '20.30.54.111.'
      end
    end

    context 'without append dot' do
      it 'should returns an empty string on level 1' do
        component.stub(:splitted_masked_number_filled => ['20'])
        component.stub(:class_number_level => 1)

        expect(subject.persisted_parent_masked_number(true)).to eq ''
      end

      it 'should returns an empty string on level 2' do
        component.stub(:splitted_masked_number_filled => ['20', '30'])
        component.stub(:class_number_level => 2)

        expect(subject.persisted_parent_masked_number).to eq '20'
      end

      it 'should returns an empty string on level 3' do
        component.stub(:splitted_masked_number_filled => ['20', '30', '54'])
        component.stub(:class_number_level => 3)

        expect(subject.persisted_parent_masked_number).to eq '20.30'
      end

      it 'should returns an empty string on level 4' do
        component.stub(:splitted_masked_number_filled => ['20', '30', '54', '111'])
        component.stub(:class_number_level => 4)

        expect(subject.persisted_parent_masked_number).to eq '20.30.54'
      end

      it 'should returns an empty string on level 5' do
        component.stub(:splitted_masked_number_filled => ['20', '30', '54', '111', '222'])
        component.stub(:class_number_level => 5)

        expect(subject.persisted_parent_masked_number).to eq '20.30.54.111'
      end
    end
  end

  context '#last_level_class_number' do
    it 'should returns an empty string when at level 1' do
      component.stub(:splitted_masked_number_filled => [])

      expect(subject.last_level_class_number).to eq ''
    end

    it 'should returns the first when at level 1' do
      component.stub(:splitted_masked_number_filled => ['20'])

      expect(subject.last_level_class_number).to eq '20'
    end

    it 'should returns the second when at level 2' do
      component.stub(:splitted_masked_number_filled => ['20', '30'])

      expect(subject.last_level_class_number).to eq '30'
    end
  end
end
