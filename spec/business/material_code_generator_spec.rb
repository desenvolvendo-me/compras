require 'unit_helper'
require 'active_support/time'
require 'app/business/material_code_generator'

describe MaterialCodeGenerator do
  let :material_storage do
    double('Material', :where => [1, 2])
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

  it 'next_value should be 3' do
    MaterialCodeGenerator.new(material, material_storage).next_value.should eq 3
  end

  it 'should generate code to 211-33-4' do
    MaterialCodeGenerator.new(material, material_storage).generate!.should eq '211333'
  end
end
