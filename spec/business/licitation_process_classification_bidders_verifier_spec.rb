require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/licitation_process_classification_bidders_verifier'

describe LicitationProcessClassificationBiddersVerifier do

  let :licitation_process do
    double('LicitationProcess',
      :id => 1,
      :disqualify_by_documentation_problem => false,
      :disqualify_by_maximum_value => false,
      :consider_law_of_proposals => false
    )
  end

  let :bidder do
    double('LicitationProcessBidder', :id => 11, :benefited => false, :status => :enabled)
  end

  let :licitation_process_bidders do
    [bidder]
  end

  let :verifier do
    LicitationProcessClassificationBiddersVerifier.new(licitation_process)
  end

  context 'disable bidders by documentation problem' do
    before do
      licitation_process.stub(:licitation_process_bidders => [bidder])
      licitation_process.stub(:disqualify_by_documentation_problem => true)
    end

    it 'should disable bidder' do
      bidder.stub(:benefited => false, :filled_documents? => false, :expired_documents? => true)

      bidder.should_receive(:inactive!).and_return(true)
      bidder.should_receive(:save!).and_return(true)

      verifier.verify!
    end

    it 'should disable bidder' do
      bidder.stub(:benefited => false, :filled_documents? => true, :expired_documents? => true)

      bidder.should_receive(:inactive!).and_return(true)
      bidder.should_receive(:save!).and_return(true)

      verifier.verify!
    end

    it 'should do nothing' do
      licitation_process.stub(:disqualify_by_documentation_problem => false)

      verifier.verify!
    end

    it 'should enable bidder' do
      bidder.stub(:benefited => false, :filled_documents? => true, :expired_documents? => false)

      bidder.should_receive(:active!).and_return(true)
      bidder.should_receive(:save!).and_return(true)

      verifier.verify!
    end
  end

  context 'disable bidders if unit price is greater than item unit price' do
    before do
      licitation_process.stub(:licitation_process_bidders => [bidder])
      licitation_process.stub(:disqualify_by_maximum_value => true)
    end

    it 'should disable bidder' do
      bidder.stub(:has_proposals_unit_price_greater_than_budget_allocation_item_unit_price => true)

      bidder.should_receive(:inactive!).and_return(true)
      bidder.should_receive(:save!).and_return(true)

      verifier.verify!
    end

    it 'should do nothing' do
      bidder.stub(:has_proposals_unit_price_greater_than_budget_allocation_item_unit_price => false)

      verifier.verify!
    end
  end
end
