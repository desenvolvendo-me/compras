# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/materials_control_decorator'

describe MaterialsControlDecorator do
  describe '#minimum_quantity' do
    it 'should return minimum_quantity' do
      component.stub(:minimum_quantity).and_return(10)

      expect(subject.minimum_quantity).to eq "10,00"
    end
  end

  describe '#maximum_quantity' do
    it 'should return maximum_quantity' do
      component.stub(:maximum_quantity).and_return(10)

      expect(subject.maximum_quantity).to eq "10,00"
    end
  end

  describe '#average_quantity' do
    it 'should return average_quantity' do
      component.stub(:average_quantity).and_return(10)

      expect(subject.average_quantity).to eq "10,00"
    end
  end

  describe '#replacement_quantity' do
    it 'should return replacement_quantity' do
      component.stub(:replacement_quantity).and_return(10)

      expect(subject.replacement_quantity).to eq "10,00"
    end
  end
end
