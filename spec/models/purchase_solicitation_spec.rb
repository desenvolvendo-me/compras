# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_item'

describe PurchaseSolicitation do
  it 'should return the id in to_s method' do
    subject.justification = 'Precisamos de mais cadeiras'

    subject.to_s.should eq 'Precisamos de mais cadeiras'
  end

  it {should belong_to :responsible }
  it {should belong_to :budget_allocation }
  it {should belong_to :delivery_location }
  it {should belong_to :liberator }
  it {should belong_to :organogram }
  it {should have_and_belong_to_many :budget_allocations }

  context "validations" do
    it { should validate_presence_of :accounting_year }
    it { should validate_presence_of :request_date }
    it { should validate_presence_of :delivery_location_id }
    it { should validate_presence_of :responsible_id }
    it { should validate_presence_of :kind }

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
  end
end
