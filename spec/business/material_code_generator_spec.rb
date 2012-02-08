require 'unit_helper'
require 'active_support/time'
require 'app/business/material_code_generator'

describe MaterialCodeGenerator do
  context 'without previous material' do
    let :material_storage do
      double('Material', :order => double(:where => []))
    end

    let :materials_group do
      double('MaterialsGroup', :id => 1, :group_number => 211)
    end

    let :materials_class do
      double('MaterialsClass', :id => 2, :class_number => 33)
    end

    let :material do
      double('Material', :materials_group => materials_group, :materials_class => materials_class)
    end

    it 'next_value should be 1' do
      MaterialCodeGenerator.new(material, material_storage).next_value.should eq 1
    end

    it 'should generate code to 211331' do
      MaterialCodeGenerator.new(material, material_storage).generate!.should eq '211331'
    end
  end

  context 'with previous material' do
    let :material_storage do
      double('Material', :order => double(:where => [double('Material', :code => '2113325')]))
    end

    let :materials_group do
      double('MaterialsGroup', :id => 1, :group_number => 211)
    end

    let :materials_class do
      double('MaterialsClass', :id => 2, :class_number => 33)
    end

    let :material do
      double('Material', :materials_group => materials_group, :materials_class => materials_class)
    end

    let :previous_material do
      double('Material', :code => 25)
    end

    it 'next_value should be 26' do
      MaterialCodeGenerator.new(material, material_storage).next_value.should eq 26
    end

    it 'should generate code to 2113326' do
      MaterialCodeGenerator.new(material, material_storage).generate!.should eq '2113326'
    end
  end
end
