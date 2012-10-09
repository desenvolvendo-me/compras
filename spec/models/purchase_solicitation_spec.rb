# encoding: utf-8
require 'model_helper'
require 'lib/annullable'
require 'app/models/budget_allocation'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/models/purchase_solicitation_liberation'
require 'app/models/resource_annul'
require 'app/models/purchase_solicitation_item_group_material_purchase_solicitation'
require 'app/models/material.rb'
require 'app/models/direct_purchase'
require 'app/models/budget_structure.rb'

describe PurchaseSolicitation do
  it 'should return the code/accounting_year in to_s method' do
    subject.accounting_year = 2012
    subject.stub(:budget_structure => "01.01.001 - SECRETARIA DA EDUCAÇÃO")
    subject.stub(:responsible => "CARLOS DORNELES")
    subject.code = 2

    expect(subject.to_s).to eq "2/2012 01.01.001 - SECRETARIA DA EDUCAÇÃO - RESP: CARLOS DORNELES"
  end

  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:destroy).order(:id) }
  it { should have_many(:items).through(:purchase_solicitation_budget_allocations)}
  it { should have_many(:purchase_solicitation_liberations).dependent(:destroy).order(:sequence) }
  it { should have_many(:purchase_solicitation_item_group_material_purchase_solicitations).dependent(:destroy)}
  it { should have_one(:annul).dependent(:destroy) }
  it { should have_one(:direct_purchase) }
  it { should belong_to :responsible }
  it { should belong_to :delivery_location }
  it { should belong_to :liberator }
  it { should belong_to :budget_structure }

  it { should auto_increment(:code).by(:accounting_year) }

  it "must delegate the amount to budget_allocation" do
    subject.stub(:budget_allocation).and_return double("Allocation", :amount  => '400,00')

    expect(subject.budget_allocation_amount).to eq("400,00")
  end

  context "validations" do
    it { should validate_presence_of :accounting_year }
    it { should validate_numericality_of :accounting_year }
    it { should validate_presence_of :request_date }
    it { should validate_presence_of :delivery_location }
    it { should validate_presence_of :responsible }
    it { should validate_presence_of :kind }
    it { should validate_duplication_of(:budget_allocation_id).on(:purchase_solicitation_budget_allocations) }

    it { should_not allow_value('a2012').for(:accounting_year) }
    it { should allow_value('2012').for(:accounting_year) }
  end

  describe '#annul!' do
    it 'should updates the service status to annulled' do
      subject.should_receive(:update_column).with(:service_status, PurchaseSolicitationServiceStatus::ANNULLED)

      subject.annul!
    end
  end

  describe '#change_status!' do
    let :liberation do
      double :liberation
    end

    it 'should updates the service status to annulled' do
      subject.stub(:liberation).and_return(liberation)
      subject.should_receive(:update_column).with(:service_status, 'liberated')

      subject.change_status!('liberated')
    end
  end

  it 'should be editable when is pending' do
    subject.service_status = PurchaseSolicitationServiceStatus::PENDING

    expect(subject).to be_editable
  end

  it 'should be editable when is returned' do
    subject.service_status = PurchaseSolicitationServiceStatus::RETURNED

    expect(subject).to be_editable
  end

  it 'should not be editable when is not returned neither pending' do
    subject.service_status = PurchaseSolicitationServiceStatus::ANNULLED

    expect(subject).not_to be_editable
  end

  describe "#purchase_solicitation_budget_allocations_by_material" do
    it "returns all budget allocations with materials of a given set" do
      material_ids = [-1, -2]
      budget_allocations = double(:budget_allocations)
      subject.stub(:purchase_solicitation_budget_allocations => budget_allocations)

      budget_allocations.should_receive(:by_material).with(material_ids)
      subject.purchase_solicitation_budget_allocations_by_material(material_ids)
    end
  end

  describe "#can_be_grouped?" do
    it "returns true if purchase solicitation is approved" do
      subject.service_status = "liberated"

      expect(subject.can_be_grouped?).to be true
    end

    it "returns true if purchase solicitation is pending" do
      subject.service_status = "pending"

      expect(subject.can_be_grouped?).to be true
    end

    it "returns true if purchase solicitation is partially fulfilled" do
      subject.service_status = "partially_fulfilled"

      expect(subject.can_be_grouped?).to be true
    end

    it "returns false otherwise" do
      subject.service_status = "attended"

      expect(subject.can_be_grouped?).to be false
    end
  end

  describe '#clear_items_fulfiller_and_status' do
    it 'should clear_fulfiller_and_status of all items' do
      item1 = double(:item1)
      item2 = double(:item2)

      subject.stub(:items).and_return([item1, item2])

      item1.should_receive(:clear_fulfiller_and_status)
      item2.should_receive(:clear_fulfiller_and_status)

      subject.clear_items_fulfiller_and_status
    end
  end

  describe '#liberate!' do
    it 'should change service_status to liberated' do
      subject.should_receive(:update_column).with(:service_status, 'liberated')

      subject.liberate!
    end
  end

  describe '#attend!' do
    it 'should change service_status to attended' do
      item1 = double(:item1)
      item2 = double(:item2)

      item1.should_receive(:attend!)
      item2.should_receive(:attend!)

      subject.stub(:items).and_return([item1, item2])
      subject.should_receive(:update_column).with(:service_status, 'attended')

      subject.attend!
    end
  end
end
