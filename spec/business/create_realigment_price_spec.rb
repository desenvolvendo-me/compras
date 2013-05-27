require 'unit_helper'
require 'app/business/create_realigment_price'

describe CreateRealigmentPrice do
  let(:item_one) { double('PurchaseProcessItem', id: 1) }
  let(:item_two) { double('PurchaseProcessItem', id: 2) }
  let(:item_three) { double('PurchaseProcessItem', id: 3) }
  let(:items) { [item_one, item_two, item_three] }
  let(:realignment_prices) { [] }
  let(:creditor_one) { double('Creditor', id: 1) }
  let(:creditor_two) { double('Creditor', id: 2) }
  let(:creditors) { [creditor_one, creditor_two] }
  let(:licitation_process) { double('LicitationProcess', id: 1, creditors: creditors, items: items) }
  let(:proposal) { double('PurchaseProcessCreditorProposal', id: 1,
    unit_price: 100.00, creditor: creditor_one, realigment_prices: realignment_prices, licitation_process: licitation_process) }
  let(:repository) { double(:repository) }

  subject do
    described_class.new(proposal, repository)
  end

  describe "#create_realigment_price" do
    context "when realignment_prices is empty" do
      it "should build realignment prices" do
        repository.stub(:licitation_process).and_return licitation_process
        repository.stub(:items).and_return items
        repository.stub(:realigment_prices).and_return realignment_prices

        realignment_prices.should_receive(:build).with(item: item_one, brand: "", price: 0.0, quantity: 0, delivery_date: "")
        realignment_prices.should_receive(:build).with(item: item_two, brand: "", price: 0.0, quantity: 0, delivery_date: "")
        realignment_prices.should_receive(:build).with(item: item_three, brand: "", price: 0.0, quantity: 0, delivery_date: "")

        subject.create_realigment_price!
      end
    end
  end
end
