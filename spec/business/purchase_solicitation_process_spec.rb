require 'unit_helper'
require 'enumerate_it'
require 'app/business/purchase_solicitation_process'
require 'app/enumerations/purchase_solicitation_service_status'

describe PurchaseSolicitationProcess do
  describe "#set_solicitation" do
    let(:old_solicitation) { double(:old_solicitation) }
    let(:new_solicitation) { double(:new_solicitation) }

    it "updates the solicitation status to 'In Purchase Process'" do
      new_solicitation.should_receive(:change_status!).with(PurchaseSolicitationServiceStatus::IN_PURCHASE_PROCESS)
      described_class.update_solicitations_status(new_solicitation)
    end

    context "when the solicitation is being removed" do
      it "updates the old solicitation's status to 'Pending'" do
        old_solicitation.should_receive(:change_status!).with(PurchaseSolicitationServiceStatus::PENDING)
        described_class.update_solicitations_status(nil, old_solicitation)
      end
    end

    context "when the solicitation is being replaced" do
      it "updates the old solicitation's status to 'Pending'" do
        new_solicitation.should_receive(:change_status!).with(PurchaseSolicitationServiceStatus::IN_PURCHASE_PROCESS)
        old_solicitation.should_receive(:change_status!).with(PurchaseSolicitationServiceStatus::PENDING)

        described_class.update_solicitations_status(new_solicitation, old_solicitation)
      end
    end

    context "when old and new solicitation are the same" do
      it "it should do nothing" do
        new_solicitation.should_not_receive(:change_status!).with(PurchaseSolicitationServiceStatus::IN_PURCHASE_PROCESS)

        described_class.update_solicitations_status(new_solicitation, new_solicitation)
      end
    end
  end
end
