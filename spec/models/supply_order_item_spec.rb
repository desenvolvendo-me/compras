# encoding: utf-8
require 'model_helper'
require 'app/models/supply_order_item'
require 'app/models/licitation_process_ratification_item'

describe SupplyOrderItem do
  it { should belong_to :supply_order }
  it { should belong_to :licitation_process_ratification_item }

  it { should delegate(:material).to(:licitation_process_ratification_item).allowing_nil(true) }
  it { should delegate(:reference_unit).to(:licitation_process_ratification_item).allowing_nil(true) }
  it { should delegate(:unit_price).to(:licitation_process_ratification_item).allowing_nil(true) }
  it { should delegate(:total_price).to(:licitation_process_ratification_item).allowing_nil(true) }
  it { should delegate(:supply_order_item_balance).to(:licitation_process_ratification_item).allowing_nil(true) }

  describe "#balance" do
    it "when quantity is greater than authorized balance is greater than zero" do
      subject.stub(:quantity).and_return(3)
      subject.stub(:authorized_quantity).and_return(1)

      expect(subject.balance).to eq 2
    end
  end

  describe "#quantity" do
    it "when ratification item quantity is nil" do
      allow_message_expectations_on_nil

      subject.licitation_process_ratification_item = LicitationProcessRatificationItem.new
      expect(subject.quantity).to eq(0)
    end

    it "when ratification item quantity is 2" do
      pending 'Não está passando'
      subject.licitation_process_ratification_item.stub(:quantity).and_return(2)
      expect(subject.quantity).to eq(2)
    end
  end

  it "#authorization_quantity_should_be_lower_than_quantity" do
    subject.stub(:real_authorization_quantity).and_return(4)
    subject.stub(:supply_order_item_balance).and_return(3)

    subject.valid?
    expect(subject.errors[:authorization_quantity]).to include("deve ser menor ou igual a 3")
  end
end
