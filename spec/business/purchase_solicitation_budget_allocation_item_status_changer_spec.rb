require 'unit_helper'
require 'app/business/purchase_solicitation_budget_allocation_item_status_changer'

describe PurchaseSolicitationBudgetAllocationItemStatusChanger do
  let :item_repository do
    double :item_repository
  end

  context 'when has only new_ids' do
    before do
      ids.stub({:new_item_ids => new_item_ids})
      ids.should_receive(:[]).with(:new_item_ids)
      ids.should_receive(:[]).with(:old_item_ids)
      described_class.new(ids)
    end

    let :ids do
      double :ids
    end

    let :new_item_ids do
      [1, 2, 3]
    end

    it 'should update status to grouped' do
      item_repository.should_receive(:group!).with(new_item_ids)

      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        {:new_item_ids => new_item_ids}
      ).change(item_repository)
    end
  end

  context 'when has new_ids and old_ids' do
    before do
      ids.stub({:new_item_ids => new_item_ids, :old_item_ids => old_item_ids})
      ids.should_receive(:[]).with(:new_item_ids)
      ids.should_receive(:[]).with(:old_item_ids)
      described_class.new(ids)
    end

    let :ids do
      double :ids
    end

    let :new_item_ids do
      [1, 2, 3]
    end

    let :old_item_ids do
      [1, 2, 3, 4]
    end

    let :remove_item_ids do
      old_item_ids - new_item_ids_persisted
    end

    let :new_item_ids_persisted do
      new_item_ids || []
    end

    it 'should update status to grouped and to pending' do
      item_repository.should_receive(:group!).with(new_item_ids)
      item_repository.should_receive(:pending!).with(remove_item_ids)

      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        {:new_item_ids => new_item_ids, :old_item_ids => old_item_ids}
      ).change(item_repository)
    end
  end

  context 'when has only old_ids' do
    before do
      ids.stub({:old_item_ids => old_item_ids})
      ids.should_receive(:[]).with(:new_item_ids)
      ids.should_receive(:[]).with(:old_item_ids)
      described_class.new(ids)
    end

    let :ids do
      double :ids
    end

    let :new_item_ids do
      nil
    end

    let :old_item_ids do
      [1, 2, 3, 4]
    end

    let :remove_item_ids do
      old_item_ids - new_item_ids_persisted
    end

    let :new_item_ids_persisted do
      new_item_ids || []
    end

    it 'should update status to pending' do
      item_repository.should_receive(:pending!).with(remove_item_ids)

      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        {:old_item_ids => old_item_ids}
      ).change(item_repository)
    end
  end
end
