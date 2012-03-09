# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_item'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/budget_allocation'

describe PurchaseSolicitation do
  it 'should return the id in to_s method' do
    subject.id = 1

    subject.to_s.should eq '1'
  end

  context "#items_total_value" do
    it "should sum the estimated total price of the items" do
      subject.stub(:items).
              and_return([
                double(:estimated_total_price => 100),
                double(:estimated_total_price => 200),
                double(:estimated_total_price => nil)
              ])

      subject.items_total_value.should eq(300)
    end
  end

  context "#budget_allocations_total_value" do
    it "should sum the estimated value of the purchase solicitation budget allocations" do
      subject.stub(:purchase_solicitation_budget_allocations).
              and_return([
                double(:estimated_value => 100),
                double(:estimated_value => 200),
                double(:estimated_value => nil)
              ])

      subject.budget_allocations_total_value.should eq(300)
    end
  end

  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many(:items).dependent(:destroy).order(:id) }
  it { should have_many(:purchase_solicitation_budget_allocations).dependent(:destroy).order(:id) }
  it {should belong_to :expense_economic_classification }
  it {should belong_to :responsible }
  it {should belong_to :budget_allocation }
  it {should belong_to :delivery_location }
  it {should belong_to :liberator }
  it {should belong_to :organogram }

  it "must delegate the amount to budget_allocation" do
    subject.stub(:budget_allocation).and_return double("Allocation", :amount  => '400,00')

    subject.budget_allocation_amount.should eq("400,00")
  end

  context "validations" do
    it { should validate_presence_of :accounting_year }
    it { should validate_numericality_of :accounting_year }
    it { should validate_presence_of :request_date }
    it { should validate_presence_of :delivery_location }
    it { should validate_presence_of :responsible }
    it { should validate_presence_of :kind }

    it { should_not allow_value('a2012').for(:accounting_year) }
    it { should allow_value('2012').for(:accounting_year) }

    it "the items with the same material should be invalid except the first" do
      item_one = subject.items.build(:material_id => 1)
      item_two = subject.items.build(:material_id => 1)

      subject.valid?

      item_one.errors.messages[:material_id].should be_nil
      item_two.errors.messages[:material_id].should include "não é permitido adicionar mais de um item com o mesmo material."
    end

    it "the items with the different material should be valid" do
      item_one = subject.items.build(:material_id => 1)
      item_two = subject.items.build(:material_id => 2)

      subject.valid?

      item_one.errors.messages[:material_id].should be_nil
      item_two.errors.messages[:material_id].should be_nil
    end

    it "the duplicated budget_allocations should be invalid except the first" do
      item_one = subject.purchase_solicitation_budget_allocations.build(:budget_allocation_id => 1)
      item_two = subject.purchase_solicitation_budget_allocations.build(:budget_allocation_id => 1)

      subject.valid?

      item_one.errors.messages[:budget_allocation_id].should be_nil
      item_two.errors.messages[:budget_allocation_id].should include "já está em uso"
    end

    it "the diferent budget_allocations should be valid" do
      item_one = subject.purchase_solicitation_budget_allocations.build(:budget_allocation_id => 1)
      item_two = subject.purchase_solicitation_budget_allocations.build(:budget_allocation_id => 2)

      subject.valid?

      item_one.errors.messages[:budget_allocation_id].should be_nil
      item_two.errors.messages[:budget_allocation_id].should be_nil
    end

    context "budget allocations total value" do
      it "should not have error when the budget_allocation_id is assigned" do
        subject.budget_allocation_id = 1

        subject.stub(:budget_allocations_total_value => 200, :items_total_value => 100)

        subject.errors.messages[:budget_allocations_total_value].should be_nil
      end

      context "when the budget_allocation_id is not assigned" do
        before do
          subject.budget_allocation_id = nil
        end

        it "should not have error when the budget allocations total value is equal to items total value" do
          subject.stub(:budget_allocations_total_value => 100, :items_total_value => 100)
          subject.valid?

          subject.errors.messages[:budget_allocations_total_value].should be_nil
        end

        it "should have error when the budget allocations total value is not equal to items total value" do
          subject.stub(:budget_allocations_total_value => 200, :items_total_value => 100)
          subject.valid?

          subject.errors.messages[:budget_allocations_total_value].should include "deve ser igual ao valor total previsto dos itens"
        end
      end
    end
  end
end
