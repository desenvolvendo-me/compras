require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/licitation_process_classification_generator'

describe LicitationProcessClassificationGenerator do

  let :licitation_process do
    double('LicitationProcess',
      :id => 1,
      :licitation_process_lots => [lot],
      :modality => 'modality',
      :type_of_calculation => 'lowest_total_price_by_item',
      :destroy_all_licitation_process_classifications => true,
      :lots_with_items => [lot],
      :disqualify_by_documentation_problem => false,
      :disqualify_by_maximum_value => false,
      :consider_law_of_proposals => false,
      :all_licitation_process_classifications => [],
      :administrative_process_presence_trading? => false,
      :items => [],
      :licitation_process_bidders => []
    )
  end

  let :licitation_process_classification_repository do
    double('LicitationProcessClassification')
  end

  let :lot do
    double(:administrative_process_budget_allocation_items => [item], :licitation_process_classifications => [])
  end

  let :item do
    double(:material => double, :unit_price => 10, :licitation_process_classifications => [])
  end

  let :bidder do
    double('LicitationProcessBidder', :id => 11, :proposals => proposals, :benefited => false, :status => :enabled,
           :administrative_process_budget_allocation_item => item, :licitation_process_classifications_by_classifiable => [])
  end

  let :licitation_process_bidders do
    [bidder]
  end

  let :proposal do
    double(:administrative_process_budget_allocation_item => item, :unit_price => 8,
           :disqualified => false, :quantity => 5, :situation => nil, :classification => nil)
  end

  let :proposals do
    [proposal]
  end

  let :classification_1 do
    double(:classifiable_type => 'LicitationProcessBidder', :classifiable_id => 1, :disqualified? => false, :classification => 2)
  end

  let :classification_2 do
    double(:classifiable_type => 'LicitationProcessBidder', :classifiable_id => 1, :disqualified? => false, :classification => 1)
  end

  let :generator do
    LicitationProcessClassificationGenerator.new(licitation_process, licitation_process_classification_repository)
  end

  context 'generate classifications by type of calculation' do
    before do
      generator.should_receive(:generate_situation!).and_return(true)

      licitation_process.stub(:licitation_process_bidders => [bidder])
    end

    it "when type of calculation equals lowest total price by item" do
      licitation_process.stub(:type_of_calculation => 'lowest_total_price_by_item')

      bidder.should_receive(:classification_by_item).with(proposals.first).and_return(1)

      licitation_process_classification_repository.should_receive(:create!).with(
        :unit_value => 8, :total_value => 40, :classification => 1, :licitation_process_bidder => bidder, :classifiable => item)

      generator.generate!
    end

    it "when type of calculation equals lowest global price" do
      licitation_process.stub(:type_of_calculation => 'lowest_global_price')

      bidder.should_receive(:global_classification).and_return(1)
      bidder.should_receive(:total_price).and_return(50)

      licitation_process_classification_repository.should_receive(:create!).with(
        :total_value => 50, :classification => 1, :licitation_process_bidder => bidder, :classifiable => bidder)

      generator.generate!
    end

    it "when type of calculation equals lowest total price by item" do
      licitation_process.stub(:type_of_calculation => 'lowest_price_by_lot')

      bidder.should_receive(:classification_by_lot).with(lot).and_return(1)
      bidder.should_receive(:proposal_total_value_by_lot).with(lot).and_return(100)

      licitation_process_classification_repository.should_receive(:create!).with(
        :total_value => 100, :classification => 1, :licitation_process_bidder => bidder, :classifiable => lot)

      generator.generate!
    end
  end

  context 'check if winner has item with zero in unit price' do
    before do
      licitation_process.stub(:all_licitation_process_classifications => [classification_1, classification_2],
                              :licitation_process_bidders => [])

      generator.should_receive(:generate_situation!).and_return(true)
    end

    it 'should check if has classification -1' do
      expect(classification_1.classification).to eq 2
      expect(classification_2.classification).to eq 1

      generator.generate!
    end

    it 'should update classification' do
      classification_2.stub(:disqualified? => true, :classification => -1)

      classification_1.should_receive(:update_column).with(:classification, 1).and_return(true)

      generator.generate!
    end
  end

  context 'disable bidders by documentation problem' do
    before do
      bidder.stub(:proposals => [])
      licitation_process.stub(:licitation_process_bidders => [bidder])
      licitation_process.stub(:disqualify_by_documentation_problem => true)

      generator.should_receive(:generate_situation!).and_return(true)
    end

    it 'should disable bidder' do
      bidder.stub(:benefited => false, :filled_documents? => false, :expired_documents? => true)

      bidder.should_receive(:inactive!).and_return(true)
      bidder.should_receive(:save!).and_return(true)

      generator.generate!
    end

    it 'should disable bidder' do
      bidder.stub(:benefited => false, :filled_documents? => true, :expired_documents? => true)

      bidder.should_receive(:inactive!).and_return(true)
      bidder.should_receive(:save!).and_return(true)

      generator.generate!
    end

    it 'should do nothing' do
      licitation_process.stub(:disqualify_by_documentation_problem => false)

      generator.generate!
    end

    it 'should enable bidder' do
      bidder.stub(:benefited => false, :filled_documents? => true, :expired_documents? => false)

      bidder.should_receive(:active!).and_return(true)
      bidder.should_receive(:save!).and_return(true)

      generator.generate!
    end
  end

  context 'disable bidders if unit price is greater than item unit price' do
    before do
      bidder.stub(:proposals => [])
      licitation_process.stub(:licitation_process_bidders => [bidder])
      licitation_process.stub(:disqualify_by_maximum_value => true)

      generator.should_receive(:generate_situation!).and_return(true)
    end

    it 'should disable bidder' do
      bidder.stub(:has_proposals_unit_price_greater_than_budget_allocation_unit_price => true)

      bidder.should_receive(:disable!).and_return(true)

      generator.generate!
    end

    it 'should do nothing' do
      bidder.stub(:has_proposals_unit_price_greater_than_budget_allocation_unit_price => false)

      generator.generate!
    end
  end

  context 'generate situation of classifications' do
    before do
      licitation_process.stub(:all_licitation_process_classifications => [classification_1, classification_2],
                              :licitation_process_bidders => [])
    end

    it 'should change classification situation to won and to lost the disqualified' do
      classification_1.stub(:disqualified? => true)

      classification_1.should_receive(:lost!).and_return(true)
      classification_2.should_receive(:won!).and_return(true)
      classification_2.should_receive(:save!).and_return(true)

      generator.generate!
    end

    it 'should change classifications situation to equalized' do
      classification_1.stub(:total_value => 10, :benefited => false)
      classification_2.stub(:total_value => 10, :benefited => false)

      classification_1.should_receive(:benefited_value).with(10).and_return(10)

      classification_1.should_receive(:equalized!).and_return(true)
      classification_2.should_receive(:equalized!).and_return(true)
      classification_1.should_receive(:save!).and_return(true)
      classification_2.should_receive(:save!).and_return(true)

      generator.generate!
    end

    it 'should change classifications situation to equalized' do
      classification_2.stub(:total_value => 9, :benefited => false)
      classification_1.stub(:total_value => 10, :benefited => true)

      classification_1.should_receive(:benefited_value).with(10).and_return(9)

      classification_1.should_receive(:equalized!).and_return(true)
      classification_2.should_receive(:equalized!).and_return(true)
      classification_1.should_receive(:save!).and_return(true)
      classification_2.should_receive(:save!).and_return(true)

      generator.generate!
    end

    it 'should change classifications to won and lost' do
      classification_2.stub(:total_value => 9, :benefited => false)
      classification_1.stub(:total_value => 10, :benefited => false)

      classification_1.should_receive(:benefited_value).with(10).and_return(10)

      classification_2.should_receive(:won!).and_return(true)
      classification_1.should_receive(:lost!).and_return(true)
      classification_1.should_receive(:save!).and_return(true)
      classification_2.should_receive(:save!).and_return(true)

      generator.generate!
    end

    it 'should change classifications to won and lost' do
      classification_2.stub(:total_value => 9, :benefited => false)
      classification_1.stub(:total_value => 11, :benefited => true)

      classification_1.should_receive(:benefited_value).with(10).and_return(10)

      classification_2.should_receive(:won!).and_return(true)
      classification_1.should_receive(:lost!).and_return(true)
      classification_1.should_receive(:save!).and_return(true)
      classification_2.should_receive(:save!).and_return(true)

      generator.generate!
    end

    it 'should change classifications to benefited won' do
      classification_2.stub(:total_value => 19, :benefited => false)
      classification_1.stub(:total_value => 20, :benefited => true)

      classification_1.should_receive(:benefited_value).with(10).and_return(18)

      classification_1.should_receive(:won!).and_return(true)
      classification_2.should_receive(:lost!).and_return(true)
      classification_1.should_receive(:save!).exactly(3).times.and_return(true)
      classification_2.should_receive(:save!).and_return(true)

      generator.generate!
    end
  end

  context 'change situation and classification of proposals by lot' do
    let :classification_lot do
      double('LicitationProcessClassification', :classification => 1, :situation => 'won',
             :classifiable => 'LicitationProcessLot', :proposals => proposals)
    end

    before do
      lot.stub(:licitation_process_classifications => [classification_lot])
      proposal.stub(:licitation_process_lot => lot)
    end

    it 'it should change classification and situation of proposal' do
      proposal.should_receive(:save!).and_return(true)
      proposal.should_receive(:situation=).with('won')
      proposal.should_receive(:classification=).with(1)

      generator.generate!
    end
  end

  context 'change situation and classification of proposals by bidder' do
    let :classification_bidder do
      double('LicitationProcessClassification', :classification => 1, :situation => 'won',
             :classifiable => 'LicitationProcessBidder', :proposals => proposals)
    end

    before do
      licitation_process.stub(:licitation_process_bidders => licitation_process_bidders, :type_of_calculation => nil)
      bidder.stub(:licitation_process_classifications_by_classifiable => [classification_bidder])
    end

    it 'it should change classification and situation of proposal' do
      proposal.should_receive(:save!).and_return(true)
      proposal.should_receive(:situation=).with('won')
      proposal.should_receive(:classification=).with(1)

      generator.generate!
    end
  end

  context 'change situation and classification of proposals by item' do
    let :classification_item do
      double('LicitationProcessClassification', :classification => 1, :situation => 'won',
             :classifiable => 'AdministrativeProcessBudgetAllocationItem', :proposals => proposals)
    end

    before do
      item.stub(:licitation_process_classifications => [classification_item])
      licitation_process.stub(:items => [item])
      proposal.stub(:administrative_budget_allocation_item => item)
    end

    it 'it should change classification and situation of proposal' do
      proposal.should_receive(:save!).and_return(true)
      proposal.should_receive(:situation=).with('won')
      proposal.should_receive(:classification=).with(1)

      generator.generate!
    end
  end
end
