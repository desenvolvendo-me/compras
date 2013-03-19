require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/licitation_process_classificator'
require 'app/business/licitation_process_classification_value'
require 'app/business/licitation_process_classification_situation_generator'

describe LicitationProcessClassificationSituationGenerator do
  subject do
    described_class.new(licitation_process)
  end

  let :licitation_process do
    double(
      'LicitationProcess',
      :id => 1,
      :bidders => [bidder],
      :lots_with_items => [lot],
      :items => [],
      :trading? => false,
      :consider_law_of_proposals => true,
      :judgment_form => judgment_form
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
      :id => 1,
      :material => double,
      :unit_price => 10,
      :licitation_process_classifications => []
    )
  end

  let :judgment_form do
    double(:judgment_form,
           :lowest_price? => true,
           :item? => false,
           :lot? => false,
           :global? => false)
  end

  context 'generate situation of classifications' do
    before do
      licitation_process.stub(
        :all_licitation_process_classifications => classifications,
        :bidders => [])
      judgment_form.stub(:global?).and_return(true)
    end

    let :classifications do
      [classification_1, classification_2]
    end

    it 'should change classification situation to won and to lost the disqualified' do
      classifications.stub(:disqualified).and_return([classification_1])

      classification_1.should_receive(:disqualified?).and_return(true)
      classification_1.should_receive(:lose!).and_return(true)

      classification_2.should_receive(:win!).and_return(true)

      subject.generate!
    end

    it 'should change classifications situation to equalized' do
      classifications.stub(:disqualified).and_return([])

      classification_1.stub(:total_value => 10, :benefited => false)
      classification_2.stub(:total_value => 10, :benefited => false)

      classification_1.should_receive(:equalize!).and_return(true)
      classification_2.should_receive(:equalize!).and_return(true)

      subject.generate!
    end

    it 'should change classifications situation to equalized' do
      classifications.stub(:disqualified).and_return([])

      licitation_process.stub(:consider_law_of_proposals => true)
      classification_2.stub(:total_value => 9, :benefited => false)
      classification_1.stub(:will_submit_new_proposal_when_draw => true)
      classification_1.stub(:total_value => 10, :benefited => true)

      classification_1.should_receive(:equalize!).and_return(true)
      classification_2.should_receive(:equalize!).and_return(true)

      subject.generate!
    end

    it 'should change classifications situation to lost' do
      classifications.stub(:disqualified).and_return([])
      licitation_process.stub(:consider_law_of_proposals => true)
      classification_2.stub(:total_value => 9, :benefited => false)
      classification_1.stub(:will_submit_new_proposal_when_draw => false)
      classification_1.stub(:total_value => 10, :benefited => true)

      classification_2.should_receive(:win!).and_return(true)
      classification_1.should_receive(:lose!).and_return(true)

      subject.generate!
    end

    it 'should change classifications to won and lost' do
      classifications.stub(:disqualified).and_return([])

      classification_2.stub(:total_value => 9, :benefited => false)
      classification_1.stub(:total_value => 10, :benefited => false)

      classification_2.should_receive(:win!).and_return(true)
      classification_1.should_receive(:lose!).and_return(true)

      subject.generate!
    end

    it 'should change classifications to won and lost' do
      classifications.stub(:disqualified).and_return([])

      licitation_process.stub(:consider_law_of_proposals => true)
      classification_2.stub(:total_value => 9, :benefited => false)
      classification_1.stub(:total_value => 11, :benefited => true)
      classification_1.stub(:will_submit_new_proposal_when_draw => false)

      classification_2.should_receive(:win!).and_return(true)
      classification_1.should_receive(:lose!).and_return(true)

      subject.generate!
    end

    it 'should change classifications to benefited won' do
      classifications.stub(:disqualified).and_return([])

      licitation_process.stub(:consider_law_of_proposals => true)
      classification_2.stub(:total_value => 19, :benefited => true)
      classification_1.stub(:total_value => 20, :benefited => false)

      classification_1.should_receive(:lose!).and_return(true)
      classification_2.should_receive(:win!).and_return(true)

      subject.generate!
    end
  end

  context 'change situation and classification of proposals by lot' do
    before do
      lot.stub(:licitation_process_classifications => licitation_process_classifications)

      proposal.stub(:licitation_process_lot => lot)

      licitation_process.stub(
        :all_licitation_process_classifications => classifications)

      judgment_form.stub(:lot?).and_return(true)
    end

    let(:classifications) { [] }
    let(:licitation_process_classifications) { [classification_lot] }

    let :classification_lot do
      double('LicitationProcessClassification', :classification => 1, :situation => 'won',
             :classifiable => 'LicitationProcessLot', :proposals => proposals,
             :disqualified? => false)
    end

    it 'it should change classification and situation of proposal' do
      licitation_process_classifications.stub(:for_active_bidders).and_return([classification_lot])
      classifications.stub(:disqualified).and_return([])

      classification_lot.should_receive(:win!)
      proposal.should_receive(:save!).and_return(true)
      proposal.should_receive(:situation=).with('won')
      proposal.should_receive(:classification=).with(1)

      subject.generate!
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
        :all_licitation_process_classifications => classifications)
      judgment_form.stub(:global?).and_return(true)
    end

    let :classifications do
      []
    end

    it 'it should change classification and situation of proposal' do
      classifications.stub(:disqualified).and_return([])

      proposal.should_receive(:save!).and_return(true)
      proposal.should_receive(:situation=).with('won')
      proposal.should_receive(:classification=).with(1)

      subject.generate!
    end
  end

  context 'change situation and classification of proposals by item' do
    let :classification_item do
      double('LicitationProcessClassification', :classification => 1, :situation => 'won',
             :classifiable => 'AdministrativeProcessBudgetAllocationItem',
             :proposals => proposals, :disqualified? => false)
    end

    before do
      item.stub(:licitation_process_classifications => [classification_item])
      proposal.stub(:administrative_process_budget_allocation_item => item)
      licitation_process.stub(
        :items => [item],
        :all_licitation_process_classifications => classifications,
        :classifications => classifications)

      judgment_form.stub(:item?).and_return(true)
    end

    let :classifications do
      []
    end

    let(:for_active_bidders) { double(:for_active_bidders)}

    it 'it should change classification and situation of proposal' do
      classifications.stub(:for_active_bidders).and_return(for_active_bidders)
      for_active_bidders.should_receive(:for_item).with(1).and_return([classification_item])
      classifications.stub(:disqualified).and_return([])

      classification_item.should_receive(:win!)
      proposal.should_receive(:save!).and_return(true)
      proposal.should_receive(:situation=).with('won')
      proposal.should_receive(:classification=).with(1)

      subject.generate!
    end
  end
end
