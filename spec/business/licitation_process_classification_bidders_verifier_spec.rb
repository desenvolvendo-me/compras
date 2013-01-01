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
    double('Bidder', :id => 11, :benefited => false, :status => :enabled)
  end

  subject do
    described_class.new(licitation_process)
  end

  context 'disable bidders by documentation problem' do
    before do
      licitation_process.stub(:bidders => [bidder])
      licitation_process.stub(:disqualify_by_documentation_problem => true)
    end

    it 'activate bidder when it does not have problem with documentation' do
      licitation_process.stub(:disqualify_by_documentation_problem => false)
      bidder.stub(:has_documentation_problem? => false)
      subject.stub(:validate_bidder_by_maximum_value?).and_return(true)

      bidder.should_receive(:activate!)

      subject.verify!
    end

    context 'bidder is not benefited by law of proposals' do
      it 'inactivates the bidder if it has documentation problems' do
        bidder.stub(:benefited_by_law_of_proposals? => false,
                    :has_documentation_problem? => true)
        subject.stub(:validate_bidder_by_maximum_value?).and_return(true)

        bidder.should_receive(:inactivate!)

        subject.verify!
      end
    end

    it 'activates the bidder if documents are OK' do
      bidder.stub(:has_documentation_problem? => false)
      subject.stub(:validate_bidder_by_maximum_value?).and_return(true)

      bidder.should_receive(:activate!)

      subject.verify!
    end
  end

  context 'disable bidders if unit price is greater than item unit price' do
    before do
      licitation_process.stub(:bidders => [bidder])
      licitation_process.stub(:disqualify_by_maximum_value => true)
    end

    it 'should disable bidder' do
      bidder.stub(:has_proposals_unit_price_greater_than_budget_allocation_item_unit_price? => true)
      subject.stub(:validate_bidder_by_maximum_value?).and_return(true)

      bidder.should_receive(:activate!)
      bidder.should_receive(:inactivate!)

      subject.verify!
    end

    it 'should activate bidder' do
      bidder.stub(:has_proposals_unit_price_greater_than_budget_allocation_item_unit_price? => false)

      subject.stub(:validate_bidder_by_maximum_value?).and_return(true)

      bidder.should_receive(:activate!)

      subject.verify!
    end
  end
end
