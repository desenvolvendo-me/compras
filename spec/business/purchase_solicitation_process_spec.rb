require 'unit_helper'
require 'ostruct'
require 'app/business/purchase_solicitation_process'

describe PurchaseSolicitationProcess do
  describe ".initialize" do
    it "initializes the business object with the purchase process" do
      process = double(:process)
      purchase_process = PurchaseSolicitationProcess.new(process)
      expect(purchase_process.process).to eq process
    end
  end

  describe "#set_solicitation" do
    let(:in_process_status) { double(:in_process_status) }
    let(:pending_status) { double(:pending_status) }
    let(:solicitation) { double(:solicitation).as_null_object }
    let(:process) { OpenStruct.new }

    let(:purchase_solicitation_process) do
      PurchaseSolicitationProcess.new(process, :in_process_status => in_process_status,
                                               :pending_status => pending_status)
    end

    before do
      process.stub(:save! => true)
    end

    it "sets the purchase solicitation attribute in the process" do
      purchase_solicitation_process.set_solicitation(solicitation)
      expect(process.purchase_solicitation).to eq solicitation
    end

    it "updates the solicitation status to 'In Purchase Process'" do
      solicitation.should_receive(:change_status!).with(in_process_status)
      purchase_solicitation_process.set_solicitation(solicitation)
    end

    context "when the solicitation is being replaced" do
      it "updates the old solicitation's status to 'Pending'" do
        old_solicitation = double(:old_solicitation)
        process.purchase_solicitation = old_solicitation

        old_solicitation.should_receive(:change_status!).with(pending_status)
        purchase_solicitation_process.set_solicitation(solicitation)
      end
    end
  end
end
