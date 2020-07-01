require 'model_helper'
require 'app/models/pledge_item'

describe PledgeItem do
  describe '#supply_order_items' do
    it 'should return the supply_order_items by pledge_item' do
      repository = double(:repository)
      subject.stub(id: 3)

      repository.should_receive(:by_pledge_item_id).with 3

      subject.supply_order_items(repository)
    end
  end

  describe '#authorized_quantity' do
    it "should sum the authorization_quantity's supply_order_items" do
      supply_order_item1 = double(:supply_order_item1, authorization_quantity: 5)
      supply_order_item2 = double(:supply_order_item2, authorization_quantity: 3)

      subject.should_receive(:supply_order_items).and_return [supply_order_item1, supply_order_item2]

      expect(subject.authorized_quantity).to eq 8
    end
  end

  describe '#authorized_value' do
    it "should sum the authorization_value's supply_order_items" do
      supply_order_item1 = double(:supply_order_item1, authorization_value: 50.8)
      supply_order_item2 = double(:supply_order_item2, authorization_value: 3)

      subject.should_receive(:supply_order_items).and_return [supply_order_item1, supply_order_item2]

      expect(subject.authorized_value).to eq 53.8
    end
  end

  describe '#supply_order_item_balance' do
    it 'should the quantity subtracted from authorized_quantity' do
      subject.stub(quantity: 10)
      subject.stub(authorized_quantity: 3)

      expect(subject.supply_order_item_balance).to eq 7
    end
  end

  describe '#supply_order_item_value_balance' do
    it 'should the estimated_total_price subtracted from authorized_value' do
      subject.stub(estimated_total_price: 15)
      subject.stub(authorized_value: 10)

      expect(subject.supply_order_item_value_balance).to eq 5
    end
  end
end
