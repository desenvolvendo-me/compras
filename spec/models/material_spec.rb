# encoding: utf-8
require 'model_helper'
require 'app/models/material'

describe Material do
  it 'should return code and description as to_s method' do
    subject.code = '01'
    subject.description = 'Manga'
    subject.to_s.should eq '01 - Manga'
  end

  it { should validate_presence_of :materials_group_id }
  it { should validate_presence_of :materials_class_id }
  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
  it { should validate_presence_of :material_characteristic }
  it { should validate_presence_of :reference_unit_id }

  it "should validate presence of material_type only if material_characteristic is material" do
    subject.should_not validate_presence_of(:material_type)

    subject.material_characteristic = MaterialCharacteristic::MATERIAL

    subject.should validate_presence_of(:material_type)
  end

  it "should validate presence of service_or_contract_type only if material_characteristic is service" do
    subject.should_not validate_presence_of(:service_or_contract_type)

    subject.material_characteristic = MaterialCharacteristic::SERVICE

    subject.should validate_presence_of(:service_or_contract_type)
  end

  it "must be valid if class and group are related" do
    subject.stub(:materials_group_id).and_return 1
    subject.stub(:materials_class).and_return double("Class", :materials_group_id => 1)

    subject.valid?
    subject.errors.messages[:materials_class_id].should_not include "não faz parte do grupo selecionado"
  end

  it "must be invalid if class and group are not related" do
    subject.stub(:materials_group_id).and_return 2
    subject.stub(:materials_class).and_return double("Class", :materials_group_id => 1)

    subject.valid?
    subject.errors.messages[:materials_class_id].should include "não faz parte do grupo selecionado"
  end
end
