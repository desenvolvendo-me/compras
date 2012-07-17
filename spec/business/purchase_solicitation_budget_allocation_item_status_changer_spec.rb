require 'unit_helper'
require 'app/business/purchase_solicitation_budget_allocation_item_status_changer'

describe PurchaseSolicitationBudgetAllocationItemStatusChanger do
  subject do
    described_class.new(items_ids, old_items_ids)
  end

  let :items do
    double :items
  end

  context 'when has only items_ids' do
    let :items_ids do
      double :items_ids
    end

    let :old_items_ids do
      nil
    end

    it 'should update status' do
      subject.stub(:items).with( items_ids ).and_return(items)

      items.should_receive(:grouped!)

      subject.change
    end
  end

  context 'when has items_ids and old_items_ids' do
    let :items_ids do
      double :items_ids
    end

    let :old_items_ids do
      double :old_items_ids
    end

    let :removed_items_ids do
      double :removed_items_ids
    end

    it 'should update status' do
      subject.stub(:items).with( items_ids ).and_return(items)
      subject.stub(:items).with( removed_items_ids ).and_return(items)
      subject.stub(:removed_items_ids).and_return(removed_items_ids)

      items.should_receive(:grouped!)
      items.should_receive(:pending!)

      subject.change
    end
  end
end
