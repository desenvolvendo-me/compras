# encoding: utf-8
require 'model_helper'
require 'app/models/material'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/models/pledge_item'
require 'app/models/direct_purchase_budget_allocation_item'
require 'app/models/administrative_process_budget_allocation_item'
require 'app/models/price_collection_lot_item'
require 'app/models/creditor_material'
require 'app/models/purchase_solicitation_item_group_material'

describe Material do
  describe 'default values' do
    it 'uses false as default for perishable' do
      subject.perishable.should be false
    end

    it 'uses false as default for storable' do
      subject.storable.should be false
    end

    it 'uses false as default for combustible' do
      subject.combustible.should be false
    end
  end

  it 'should return code and description as to_s method' do
    subject.code = '01'
    subject.description = 'Manga'
    subject.to_s.should eq '01 - Manga'
  end

  it { should belong_to :expense_nature }
  it { should have_many :pledge_items }
  it { should have_and_belong_to_many :licitation_objects }
  it { should have_many(:direct_purchase_budget_allocation_items).dependent(:restrict) }
  it { should have_many(:administrative_process_budget_allocation_items).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_budget_allocation_items).dependent(:restrict) }
  it { should have_many(:price_collection_lot_items).dependent(:restrict) }
  it { should have_many(:creditor_materials).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_item_group_materials).dependent(:destroy) }

  it { should validate_presence_of :materials_class }
  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
  it { should validate_presence_of :material_characteristic }
  it { should validate_presence_of :reference_unit }

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

  context "with licitation_object" do
    let :licitation_objects do
      [ double('licitation_object') ]
    end

    it "should not destroy if has licitation_processes" do
      subject.stub(:licitation_objects => licitation_objects)

      subject.run_callbacks(:destroy)

      subject.errors[:base].should include "Este registro não pôde ser apagado pois há outros cadastros que dependem dele"
    end
  end

  it "should destroy if does not have licitation_processes" do
    subject.run_callbacks(:destroy)

    subject.errors[:base].should_not include "Este registro não pôde ser apagado pois há outros cadastros que dependem dele"
  end
end
