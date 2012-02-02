# encoding: utf-8
require 'model_helper'
require 'app/models/material'

describe Material do
  it 'should return name as to_s method' do
    subject.code = '01'
    subject.name = 'Manga'
    subject.to_s.should eq '01 - Manga'
  end

  it { should validate_presence_of :materials_group_id }
  it { should validate_presence_of :materials_class_id }
  it { should validate_presence_of :code }
  it { should validate_presence_of :name }
  it { should validate_presence_of :material_characteristic }
  it { should validate_presence_of :reference_unit_id }

  it "should validate presence of material_type only if material_characteristic is material" do
    subject.material_characteristic = MaterialCharacteristic::MATERIAL
    subject.material_type = ''

    subject.should_not be_valid

    subject.errors[:material_type].should include("não pode ficar em branco")
  end

  it "should validate presence of service_type only if material_characteristic is material" do
    subject.material_characteristic = MaterialCharacteristic::SERVICE
    subject.service_type_id = nil

    subject.should_not be_valid

    subject.errors[:service_type_id].should include("não pode ficar em branco")
  end
end
