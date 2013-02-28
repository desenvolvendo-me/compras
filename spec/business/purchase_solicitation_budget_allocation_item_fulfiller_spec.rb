require 'unit_helper'
require 'app/business/purchase_solicitation_budget_allocation_item_fulfiller'

describe PurchaseSolicitationBudgetAllocationItemFulfiller do
  let(:item_group) { double(:item_group) }
  let(:direct_purchase) { double(:direct_purchase) }
  let(:licitation_process) { double(:licitation_process) }
  let(:process) { double(:process) }

  context 'when have an item group' do
    subject do
      described_class.new( :purchase_solicitation_item_group => item_group )
    end

    it 'should remove fulfill_items_from_item_group when has not a process' do
      item_group.should_receive(:fulfill_items).with(nil)

      subject.fulfill
    end

    context 'when have a process' do
      subject do
        described_class.new(
          :purchase_solicitation_item_group => item_group,
          :add_fulfill => true
        )
      end

      it 'should fulfill_items_from_item_group with process' do
        item_group.should_receive(:fulfill_items)

        subject.fulfill
      end
    end
  end

  context 'when have an direct_purchase' do
    subject do
      described_class.new( :direct_purchase => direct_purchase )
    end

    it 'should remove fulfill_items_from_item_group when has not a process' do
      direct_purchase.should_receive(:remove_fulfill_purchase_solicitation_items)

      subject.fulfill
    end

    context 'when have a process' do
      subject do
        described_class.new(
          :direct_purchase => direct_purchase,
          :add_fulfill => true
        )
      end

      it 'should fulfill_items_from_item_group with process' do
        direct_purchase.should_receive(:fulfill_purchase_solicitation_items)

        subject.fulfill
      end
    end
  end

  context 'when have an licitation_process' do
    subject do
      described_class.new( :licitation_process => licitation_process )
    end

    it 'should remove fulfill_items_from_item_group when has not a process' do
      licitation_process.should_receive(:remove_fulfill_purchase_solicitation_items)

      subject.fulfill
    end

    context 'when have a process' do
      subject do
        described_class.new(
          :licitation_process => licitation_process,
          :add_fulfill => true
        )
      end

      it 'should fulfill_items_from_item_group with process' do
        licitation_process.should_receive(:fulfill_purchase_solicitation_items)

        subject.fulfill
      end
    end
  end
end
