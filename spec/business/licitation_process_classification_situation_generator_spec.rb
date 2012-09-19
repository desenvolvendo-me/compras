require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/licitation_process_classification_situation_generator'

describe LicitationProcessClassificationSituationGenerator do

  let :licitation_process do
    double(
      'LicitationProcess',
      :id => 1,
      :bidders => [bidder],
      :lots_with_items => [lot],
      :items => [],
      :administrative_process_presence_trading? => false,
      :consider_law_of_proposals => true
    )
  end

  let :bidders do
    [bidder]
  end

  let :bidder do
    double(
      'Bidder',
      :id => 11,
      :proposals => proposals,
      :benefited => false,
      :status => :enabled,
      :licitation_process_classifications_by_classifiable => []
    )
  end

  let :proposal do
    double(
      :proposal,
      :unit_price => 8,
      :disqualified => false,
      :quantity => 5,
      :situation => nil,
      :classification => nil
    )
  end

  let :proposals do
    [proposal]
  end

  let :classification_1 do
    double(
      :classification_1,
      :classifiable_type => 'Bidder',
      :classifiable_id => 1,
      :disqualified? => false,
      :classification => 2,
      :total_value => 100
    )
  end

  let :classification_2 do
    double(
      :classification_2,
      :classifiable_type => 'Bidder',
      :classifiable_id => 1,
      :disqualified? => false,
      :classification => 1,
      :total_value => 50
    )
  end

  let :lot do
    double(
      :lot,
      :administrative_process_budget_allocation_items => [item],
      :licitation_process_classifications => []
    )
  end

  let :item do
    double(
      :item,
      :material => double,
      :unit_price => 10,
      :licitation_process_classifications => []
    )
  end

  let :generator do
    LicitationProcessClassificationSituationGenerator.new(licitation_process)
  end

  context 'generate situation of classifications' do
    before do
      licitation_process.stub(
        :all_licitation_process_classifications => classifications,
        :bidders => []
      )
    end

    let :classifications do
      [classification_1, classification_2]
    end

    it 'should change classification situation to won and to lost the disqualified' do
      classifications.stub(:disqualified).and_return([classification_1])

      classification_1.should_receive(:disqualified?).and_return(true)
      classification_1.should_receive(:lose!).and_return(true)

      classification_2.should_receive(:win!).and_return(true)

      generator.generate!
    end

    it 'should change classifications situation to equalized' do
      classifications.stub(:disqualified).and_return([])

      classification_1.stub(:total_value => 10, :benefited => false)
      classification_2.stub(:total_value => 10, :benefited => false)

      classification_1.should_receive(:equalize!).and_return(true)
      classification_2.should_receive(:equalize!).and_return(true)

      generator.generate!
    end

    it 'should change classifications situation to equalized' do
      classifications.stub(:disqualified).and_return([])

      licitation_process.stub(:consider_law_of_proposals => true)
      classification_2.stub(:total_value => 9, :benefited => false)
      classification_1.stub(:total_value => 10, :benefited => true)

      classification_1.should_receive(:benefited_value).with(10).and_return(9)
      classification_2.should_receive(:benefited_value).with(10).and_return(9)

      classification_1.should_receive(:equalize!).and_return(true)
      classification_2.should_receive(:equalize!).and_return(true)

      generator.generate!
    end

    it 'should change classifications to won and lost' do
      classifications.stub(:disqualified).and_return([])

      classification_2.stub(:total_value => 9, :benefited => false)
      classification_1.stub(:total_value => 10, :benefited => false)

      classification_2.should_receive(:win!).and_return(true)
      classification_1.should_receive(:lose!).and_return(true)

      generator.generate!
    end

    it 'should change classifications to won and lost' do
      classifications.stub(:disqualified).and_return([])

      licitation_process.stub(:consider_law_of_proposals => true)
      classification_2.stub(:total_value => 9, :benefited => false)
      classification_1.stub(:total_value => 11, :benefited => true)

      classification_1.should_receive(:benefited_value).with(10).and_return(10)
      classification_2.should_receive(:benefited_value).with(10).and_return(9)

      classification_2.should_receive(:win!).and_return(true)
      classification_1.should_receive(:lose!).and_return(true)

      generator.generate!
    end

    it 'should change classifications to benefited won' do
      classifications.stub(:disqualified).and_return([])

      licitation_process.stub(:consider_law_of_proposals => true)
      classification_2.stub(:total_value => 19, :benefited => true)
      classification_1.stub(:total_value => 20, :benefited => false)

      classification_1.should_receive(:benefited_value).with(10).and_return(19)
      classification_2.should_receive(:benefited_value).with(10).and_return(20)

      classification_1.should_receive(:win!).and_return(true)
      classification_2.should_receive(:lose!).and_return(true)

      generator.generate!
    end
  end

  context 'change situation and classification of proposals by lot' do
    before do
      lot.stub(:licitation_process_classifications => [classification_lot])

      proposal.stub(:licitation_process_lot => lot)

      licitation_process.stub(
          :all_licitation_process_classifications => classifications
        )
    end

    let :classifications do
      []
    end

    let :classification_lot do
      double('LicitationProcessClassification', :classification => 1, :situation => 'won',
             :classifiable => 'LicitationProcessLot', :proposals => proposals)
    end

    it 'it should change classification and situation of proposal' do
      classifications.stub(:disqualified).and_return([])

      proposal.should_receive(:save!).and_return(true)
      proposal.should_receive(:situation=).with('won')
      proposal.should_receive(:classification=).with(1)

      generator.generate!
    end
  end

  context 'change situation and classification of proposals by bidder' do
    let :classification_bidder do
      double('LicitationProcessClassification', :classification => 1, :situation => 'won',
             :classifiable => 'Bidder', :proposals => proposals)
    end

    before do
      bidder.stub(:licitation_process_classifications_by_classifiable => [classification_bidder])

      licitation_process.stub(
        :bidders => bidders,
        :type_of_calculation => nil,
        :all_licitation_process_classifications => classifications
      )
    end

    let :classifications do
      []
    end

    it 'it should change classification and situation of proposal' do
      classifications.stub(:disqualified).and_return([])

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
      proposal.stub(:administrative_process_budget_allocation_item => item)
      licitation_process.stub(
        :items => [item],
        :all_licitation_process_classifications => classifications
      )
    end

    let :classifications do
      []
    end

    it 'it should change classification and situation of proposal' do
      classifications.stub(:disqualified).and_return([])

      proposal.should_receive(:save!).and_return(true)
      proposal.should_receive(:situation=).with('won')
      proposal.should_receive(:classification=).with(1)

      generator.generate!
    end
  end
end
