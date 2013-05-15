require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/purchase_process_classification_generator'

describe PurchaseProcessClassificationGenerator do
  subject do
    described_class.new(
      purchase_process,
      classification_repository,
      proposal_repository
    )
  end

  let :purchase_process do
    double('LicitationProcess',
      :id => 1,
      :destroy_all_licitation_process_classifications => true,
    )
  end

  let :classification_repository do
    double('LicitationProcessClassification')
  end

  let :proposal_repository do
    double('BidderProposal')
  end

  let :judgment_form do
    double(:judgment_form,
           :lowest_price? => true,
           :item? => false,
           :lot? => false,
           :global? => false)
  end

  context 'classification by lowest_global_price' do
    before do
      purchase_process.stub(
        :judgment_form => judgment_form,
        :bidders => [bidder1, bidder2, bidder3]
      )
      judgment_form.stub(:global?).and_return(true)
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

    it 'should classify bidders' do
      bidder1.stub(:total_price).and_return(10)
      bidder1.stub(:has_item_with_unit_price_equals_zero => false)

      bidder2.stub(:total_price).and_return(15)
      bidder2.stub(:has_item_with_unit_price_equals_zero => false)

      bidder3.stub(:total_price).and_return(5)
      bidder3.stub(:has_item_with_unit_price_equals_zero => false)

      classification_repository.should_receive(:create!).with(
        :total_value => 10,
        :classification => 2,
        :bidder => bidder1,
        :classifiable => bidder1
      )

      classification_repository.should_receive(:create!).with(
        :total_value => 15,
        :classification => 3,
        :bidder => bidder2,
        :classifiable => bidder2
      )

      classification_repository.should_receive(:create!).with(
        :total_value => 5,
        :classification => 1,
        :bidder => bidder3,
        :classifiable => bidder3
      )

      subject.generate!
    end

    it 'should classify disqualifying bidders that has_item_with_unit_price_equals_zero' do
      bidder1.stub(:total_price).and_return(10)
      bidder1.stub(:has_item_with_unit_price_equals_zero => false)

      bidder2.stub(:total_price).and_return(0)
      bidder2.stub(:has_item_with_unit_price_equals_zero => true)

      bidder3.stub(:total_price).and_return(5)
      bidder3.stub(:has_item_with_unit_price_equals_zero => false)

      classification_repository.should_receive(:create!).with(
        :total_value => 10,
        :classification => 2,
        :bidder => bidder1,
        :classifiable => bidder1
      )

      classification_repository.should_receive(:create!).with(
        :total_value => 0,
        :classification => -1,
        :bidder => bidder2,
        :classifiable => bidder2
      )

      classification_repository.should_receive(:create!).with(
        :total_value => 5,
        :classification => 1,
        :bidder => bidder3,
        :classifiable => bidder3
      )

      subject.generate!
    end
  end

  context 'classification by lowest_total_price_by_item' do
    before do
      purchase_process.stub(
        :judgment_form => judgment_form,
        :items => [item],
      )
      judgment_form.stub(:item?).and_return(true)
    end

    let :item do
      double(:item, :id => 1)
    end

    let :proposal1 do
      double(:proposal1, :bidder => 'Bidder1')
    end

    let :proposal2 do
      double(:proposal2, :bidder => 'Bidder2')
    end

    let :proposal3 do
      double(:proposal3, :bidder => 'Bidder3')
    end

    it 'should classify proposals' do
      proposal1.stub(:unit_price).and_return(10)
      proposal1.stub(:total_price).and_return(20)
      proposal1.stub(:purchase_process_item).and_return(item)

      proposal2.stub(:unit_price).and_return(1)
      proposal2.stub(:total_price).and_return(5)
      proposal2.stub(:purchase_process_item).and_return(item)

      proposal3.stub(:unit_price).and_return(5)
      proposal3.stub(:total_price).and_return(15)
      proposal3.stub(:purchase_process_item).and_return(item)

      proposal_repository.should_receive(:by_item_order_by_unit_price).
                          with(1).and_return([proposal2, proposal3, proposal1])

     classification_repository.should_receive(:create!).with(
       :unit_value => 1,
       :total_value => 5,
       :classification => 1,
       :bidder => 'Bidder2',
       :classifiable => item
     )

     classification_repository.should_receive(:create!).with(
       :unit_value => 5,
       :total_value => 15,
       :classification => 2,
       :bidder => 'Bidder3',
       :classifiable => item
     )

     classification_repository.should_receive(:create!).with(
       :unit_value => 10,
       :total_value => 20,
       :classification => 3,
       :bidder => 'Bidder1',
       :classifiable => item
     )

      subject.generate!
    end

    it 'should classify disqualifying proposals that has unit_price less or equal zero' do
      proposal1.stub(:unit_price).and_return(10)
      proposal1.stub(:total_price).and_return(20)
      proposal1.stub(:purchase_process_item).and_return(item)

      proposal2.stub(:unit_price).and_return(0)
      proposal2.stub(:total_price).and_return(0)
      proposal2.stub(:purchase_process_item).and_return(item)

      proposal3.stub(:unit_price).and_return(5)
      proposal3.stub(:total_price).and_return(15)
      proposal3.stub(:purchase_process_item).and_return(item)

      proposal_repository.should_receive(:by_item_order_by_unit_price).
                          with(1).and_return([proposal2, proposal3, proposal1])

     classification_repository.should_receive(:create!).with(
       :unit_value => 0,
       :total_value => 0,
       :classification => -1,
       :bidder => 'Bidder2',
       :classifiable => item
     )

     classification_repository.should_receive(:create!).with(
       :unit_value => 5,
       :total_value => 15,
       :classification => 1,
       :bidder => 'Bidder3',
       :classifiable => item
     )

     classification_repository.should_receive(:create!).with(
       :unit_value => 10,
       :total_value => 20,
       :classification => 2,
       :bidder => 'Bidder1',
       :classifiable => item
     )

      subject.generate!
    end
  end
end
