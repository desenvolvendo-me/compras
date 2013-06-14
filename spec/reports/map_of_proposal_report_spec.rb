require 'report_helper'
require 'enumerate_it'
require 'decore'
require 'app/enumerations/map_proposal_report_order'
require 'app/reports/map_of_proposal_report'

describe MapOfProposalReport do
  let :licitation_process_repository do
    double(:licitation_process_repository)
  end

  let(:purchase_process) { double('LicitationProcess', id: 1) }

  let :bidder_one do
    double('Bidder', id: 11, benefited: false, status: :enabled)
  end

  let :bidder_two do
    double('Bidder', id: 12, benefited: true, status: :enabled)
  end

  let :proposal_one do
    double('PurchaseProcessCreditorProposal', item_id: 1, unit_price: 5.99,
      creditor: bidder_one, creditor_benefited: false)
  end

  let :proposal_two do
    double('PurchaseProcessCreditorProposal', item_id: 1, unit_price: 4.99,
      creditor: bidder_two, creditor_benefited: true)
  end

  let(:proposals) { [proposal_one, proposal_two] }

  subject do
    described_class.new licitation_process_repository
  end

  it { should validate_presence_of :order }

  describe "#licitation_process" do
    it "return a licitation process" do
      licitation_process_repository.stub(:find).and_return purchase_process

      subject.stub(:licitation_process).and_return purchase_process
    end
  end

  describe "#item_creditor_proposals" do
    it "return proposals" do
      licitation_process_repository.stub(:where).and_return proposals

      subject.stub(:item_creditor_proposals).and_return proposals
    end
  end

  describe "#average_unit_price_item" do

    it "return average_unit_price_item" do
      licitation_process_repository.stub(:where).and_return proposals

      subject.stub(:average_unit_price_item).and_return 5.49
    end
  end

  describe "#average_total_price_item" do
    it "return average_total_price_item" do
      licitation_process_repository.stub(:where).and_return proposals

      subject.stub(:average_total_price_item).and_return 10.98
    end
  end
end
