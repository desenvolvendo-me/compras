require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'active_support/time'
require 'app/business/material_code_generator'

describe MaterialCodeGenerator do

  let :material_object do
    double('Material',
      :material_class => material_class
    )
  end

  let :material_repository do
    double('Material', :last_by_material_class_and_group => double('Material', :code => '02.00001'))
  end

  let :material_class do
    double('MaterialClass', :class_number => "02", :masked_number => "02", :id => 1)
  end

  context "when the materials class is changed and is present" do
    before do
      material_object.stub(:material_class_id_changed? => true, :material_class_id? => true)
    end

    it "should generate a new code" do
      material_object.should_receive(:code=).with("02.00002")

      MaterialCodeGenerator.new(material_object, material_repository).generate!
    end
  end

  context "when the materials class is not changed and is not present" do
    before do
      material_object.stub(:material_class_id_changed? => false, :material_class_id? => false)
    end

    it "should generate a new code" do
      material_object.should_receive(:code=).never

      MaterialCodeGenerator.new(material_object, material_repository).generate!
    end
  end

  context "when the materials class is not changed and is present" do
    before do
      material_object.stub(:material_class_id_changed? => true, :material_class_id? => false)
    end

    it "should generate a new code" do
      material_object.should_receive(:code=).never

      MaterialCodeGenerator.new(material_object, material_repository).generate!
    end
  end

  context "when the materials class is changed and is not present" do
    before do
      material_object.stub(:material_class_id_changed? => false, :material_class_id? => true)
    end

    it "should generate a new code" do
      material_object.should_receive(:code=).never

      MaterialCodeGenerator.new(material_object, material_repository).generate!
    end
  end
end
