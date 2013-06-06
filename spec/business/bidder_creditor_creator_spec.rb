require 'unit_helper'
require 'app/business/bidder_creditor_creator'

describe BidderCreditorCreator do
  let(:creditor_one) { double('Creditor', id: 1) }
  let(:item_one) { double('PurchaseProcessItem', id: 1, creditor: creditor_one) }
  let(:items) { [item_one] }
  let(:creditors) { [creditor_one] }
  let(:purchase_process) { double('LicitationProcess', id: 1, creditors: creditors, items: items) }
  let(:repository) { double(:repository) }

  subject do
    described_class.new(purchase_process, repository)
  end

  describe "#create_bidders" do
    context "when bidders is empty" do
      before do
        repository.stub(:purchase_process).and_return purchase_process
        purchase_process.stub(bidders: [])
      end

      it "should create a bidders" do

        purchase_process.bidders.should_receive(:create!).
          with(licitation_process_id: purchase_process.id, creditor_id: creditor_one.id)

        subject.create_bidders!
      end
    end

    context "when bidders is not empty" do
      before do
        repository.stub(:purchase_process).and_return purchase_process
        purchase_process.stub(bidders: [:creditor_one])
      end

      it 'should not create bidders' do
        purchase_process.bidders.should_not_receive(:create!)

        subject.create_bidders!
      end
    end
  end
end
