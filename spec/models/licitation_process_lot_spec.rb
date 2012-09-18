# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_lot'
require 'app/models/bidder'
require 'app/models/bidder_proposal'
require 'app/models/licitation_process_classification'
require 'app/models/administrative_process_budget_allocation_item'

describe LicitationProcessLot do
  it { should belong_to :licitation_process }
  it { should have_many(:administrative_process_budget_allocation_items).dependent(:nullify).order(:id) }
  it { should have_many(:licitation_process_classifications).dependent(:destroy) }

  it "should return 'Lote x' as to_s method" do
    subject.stub(:count_lots).and_return(1)
    expect(subject.to_s).to eq "Lote 1"
  end

  context 'item validation' do
    before do
      subject.stub(:administrative_process).and_return(administrative_process)
    end

    let :administrative_process do
      double('AdministrativeProcess', :id => 1, :to_s => '1/2012')
    end

    it "items from related administrative process should be valid" do
      item = double(:administrative_process_id => 1)
      subject.stub(:administrative_process_budget_allocation_items).and_return([item])

      subject.valid?

      expect(subject.errors.messages[:administrative_process_budget_allocation_items]).to be_nil
    end

    it "items from another administrative process should not be valid" do
      item = double(:administrative_process_id => 2)

      subject.stub(:administrative_process_budget_allocation_items).and_return([item])

      subject.valid?

      expect(subject.errors.messages[:administrative_process_budget_allocation_items]).to include "somente são permitidos itens do processo administrativo relacionado (1/2012)"
    end
  end

  it 'administrative process budget allocation items should have at least one' do
    subject.stub(:administrative_process_budget_allocation_items => [])
    subject.valid?
    expect(subject.errors.messages[:administrative_process_budget_allocation_items]).to include "deve haver ao menos um item"
  end

  context '#order_bidders_by_total_price' do
    let :bidders do
      [bidder1, bidder2, bidder3]
    end

    let :bidder1 do
      double(:bidder1)
    end

    let :bidder2 do
      double(:bidder2)
    end

    let :bidder3 do
      double(:bidder3)
    end

    it 'should order bidders by total price by lot' do
      subject.stub(:bidders).and_return(bidders)

      bidder1.stub(:proposal_total_value_by_lot).with(subject).and_return(10)
      bidder2.stub(:proposal_total_value_by_lot).with(subject).and_return(1)
      bidder3.stub(:proposal_total_value_by_lot).with(subject).and_return(5)

      expect(subject.order_bidders_by_total_price).to eq [bidder2, bidder3, bidder1]
    end
  end
end
