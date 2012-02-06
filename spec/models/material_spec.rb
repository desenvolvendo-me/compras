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
    subject.should_not validate_presence_of(:material_type)

    subject.material_characteristic = MaterialCharacteristic::MATERIAL

    subject.should validate_presence_of(:material_type)
  end

  it "should validate presence of service_or_contract_type only if material_characteristic is service" do
    subject.should_not validate_presence_of(:service_or_contract_type)

    subject.material_characteristic = MaterialCharacteristic::SERVICE

    subject.should validate_presence_of(:service_or_contract_type)
  end
end
