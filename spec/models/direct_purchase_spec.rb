# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase'

describe DirectPurchase do
  it 'should return id as to_s method' do
    subject.id = 1

    subject.to_s.should eq '1'
  end

  it { should belong_to :legal_reference }
  it { should belong_to :provider }
  it { should belong_to :organogram }
  it { should belong_to :licitation_object }
  it { should belong_to :delivery_location }
  it { should belong_to :employee }
  it { should belong_to :payment_method }
  it { should belong_to :period }
  it { should have_many(:direct_purchase_items).dependent(:destroy).order(:id) }

  it "should sum the estimated total price of the items" do
    subject.stub(:direct_purchase_items).
            and_return([
              double(:estimated_total_price => 100),
              double(:estimated_total_price => 200),
              double(:estimated_total_price => nil)
            ])

    subject.items_total_value.should eq(300)
  end

  it "the items with the same material should be invalid except the first" do
    item_one = subject.direct_purchase_items.build(:material_id => 1)
    item_two = subject.direct_purchase_items.build(:material_id => 1)

    subject.valid?

    item_one.errors.messages[:material_id].should be_nil
    item_two.errors.messages[:material_id].should include "já está em uso"
  end

  it "the items with the different material should be valid" do
    item_one = subject.direct_purchase_items.build(:material_id => 1)
    item_two = subject.direct_purchase_items.build(:material_id => 2)

    subject.valid?

    item_one.errors.messages[:material_id].should be_nil
    item_two.errors.messages[:material_id].should be_nil
  end
end
