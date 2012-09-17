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
      :all_licitation_process_classifications => [],
      :items => [],
      :bidders => []
    )
  end

  let :classification_repository do
    double('LicitationProcessClassification')
  end

  let :lot do
    double(:administrative_process_budget_allocation_items => [item], :licitation_process_classifications => [])
  end

  let :item do
    double(:material => double, :unit_price => 10, :licitation_process_classifications => [])
  end

  let :bidder do
    double('Bidder', :id => 11, :proposals => proposals, :benefited => false, :status => :enabled,
           :administrative_process_budget_allocation_item => item)
  end

  let :bidders do
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
    double(:classifiable_type => 'Bidder', :classifiable_id => 1, :disqualified? => false, :classification => 2)
  end

  let :classification_2 do
    double(:classifiable_type => 'Bidder', :classifiable_id => 1, :disqualified? => false, :classification => 1)
  end

  let :generator do
    LicitationProcessClassificationGenerator.new(licitation_process, classification_repository)
  end

  context 'generate classifications by type of calculation' do
    before do
      licitation_process.stub(:bidders => [bidder])
    end

    it "when type of calculation equals lowest total price by item" do
      licitation_process.stub(:type_of_calculation => 'lowest_total_price_by_item')

      bidder.should_receive(:classification_by_item).with(proposals.first).and_return(1)

      classification_repository.should_receive(:create!).with(
        :unit_value => 8, :total_value => 40, :classification => 1, :bidder => bidder, :classifiable => item)

      generator.generate!
    end

    it "when type of calculation equals lowest global price" do
      licitation_process.stub(:type_of_calculation => 'lowest_global_price')

      bidder.should_receive(:global_classification).and_return(1)
      bidder.should_receive(:total_price).and_return(50)

      classification_repository.should_receive(:create!).with(
        :total_value => 50, :classification => 1, :bidder => bidder, :classifiable => bidder)

      generator.generate!
    end

    it "when type of calculation equals lowest total price by item" do
      licitation_process.stub(:type_of_calculation => 'lowest_price_by_lot')

      bidder.should_receive(:classification_by_lot).with(lot).and_return(1)
      bidder.should_receive(:proposal_total_value_by_lot).with(lot).and_return(100)

      classification_repository.should_receive(:create!).with(
        :total_value => 100, :classification => 1, :bidder => bidder, :classifiable => lot)

      generator.generate!
    end
  end

  context 'check if winner has item with zero in unit price' do
    before do
      licitation_process.stub(:all_licitation_process_classifications => [classification_1, classification_2],
                              :bidders => [])
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
end
