# encoding: utf-8
require 'model_helper'
require 'app/models/material'
require 'app/models/purchase_solicitation_item'

describe Material do
  it 'should return code and description as to_s method' do
    subject.code = '01'
    subject.description = 'Manga'
    subject.to_s.should eq '01 - Manga'
  end

  it { should have_many(:purchase_solicitation_items).dependent(:restrict) }
  it { should belong_to :expense_economic_classification }

  it { should validate_presence_of :materials_class_id }
  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
  it { should validate_presence_of :material_characteristic }
  it { should validate_presence_of :reference_unit_id }
  it { should validate_presence_of :expense_economic_classification_id }

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

  it "should have false as the default value of perishable" do
    subject.perishable.should eq false
  end

  it "should have false as the default value of storable" do
    subject.storable.should eq false
  end

  it "should have false as the default value of combustible" do
    subject.combustible.should eq false
  end
end
