require 'unit_helper'
require 'app/business/purchase_solicitation_budget_allocation_item_fulfiller'

describe PurchaseSolicitationBudgetAllocationItemFulfiller do
  let(:item_group) { double(:item_group) }
  let(:direct_purchase) { double(:direct_purchase) }
  let(:administrative_process) { double(:administrative_process) }
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
          { :purchase_solicitation_item_group => item_group },
          process
        )
      end

      it 'should fulfill_items_from_item_group with process' do
        item_group.should_receive(:fulfill_items).with(process)

        subject.fulfill
      end
    end
  end

  context 'when have an direct_purchase' do
    subject do
      described_class.new( :direct_purchase => direct_purchase )
    end

    it 'should remove fulfill_items_from_item_group when has not a process' do
      direct_purchase.should_receive(:fulfill_purchase_solicitation_items).with(nil)

      subject.fulfill
    end

    context 'when have a process' do
      subject do
        described_class.new(
          { :direct_purchase => direct_purchase },
          process
        )
      end

      it 'should fulfill_items_from_item_group with process' do
      direct_purchase.should_receive(:fulfill_purchase_solicitation_items).with(process)

        subject.fulfill
      end
    end
  end

  context 'when have an administrative_process' do
    subject do
      described_class.new( :administrative_process => administrative_process )
    end

    it 'should remove fulfill_items_from_item_group when has not a process' do
      administrative_process.should_receive(:fulfill_purchase_solicitation_items).with(nil)

      subject.fulfill
    end

    context 'when have a process' do
      subject do
        described_class.new(
          { :administrative_process => administrative_process },
          process
        )
      end

      it 'should fulfill_items_from_item_group with process' do
        administrative_process.should_receive(:fulfill_purchase_solicitation_items).with(process)

        subject.fulfill
      end
    end
  end
end
