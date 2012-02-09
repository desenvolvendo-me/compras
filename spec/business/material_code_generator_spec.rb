require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'active_support/time'
require 'app/business/material_code_generator'

describe MaterialCodeGenerator do

  let :material_object do
    double('Material',
      :materials_group => materials_group,
      :materials_class => materials_class
    )
  end

  let :material_storage do
    double('Material', :last_by_materials_class_and_group => double('Material', :code => '01.02.00001'))
  end

  let :materials_group do
    double('MaterialsGroup', :group_number => "01", :id => 1)
  end

  let :materials_class do
    double('MaterialsClass', :class_number => "02", :id => 1)
  end

  context "when the materials class is changed and is present" do
    before do
      material_object.stub(:materials_class_id_changed? => true, :materials_class_id? => true)
    end

    it "should generate a new code" do
      material_object.should_receive(:code=).with("01.02.00002")

      MaterialCodeGenerator.new(material_object, material_storage).generate!
    end
  end

  context "when the materials class is not changed and is not present" do
    before do
      material_object.stub(:materials_class_id_changed? => false, :materials_class_id? => false)
    end

    it "should generate a new code" do
      material_object.should_receive(:code=).never

      MaterialCodeGenerator.new(material_object, material_storage).generate!
    end
  end

  context "when the materials class is not changed and is present" do
    before do
      material_object.stub(:materials_class_id_changed? => true, :materials_class_id? => false)
    end

    it "should generate a new code" do
      material_object.should_receive(:code=).never

      MaterialCodeGenerator.new(material_object, material_storage).generate!
    end
  end

  context "when the materials class is changed and is not present" do
    before do
      material_object.stub(:materials_class_id_changed? => false, :materials_class_id? => true)
    end

    it "should generate a new code" do
      material_object.should_receive(:code=).never

      MaterialCodeGenerator.new(material_object, material_storage).generate!
    end
  end
end
