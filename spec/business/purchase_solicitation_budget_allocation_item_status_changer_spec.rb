require 'unit_helper'
require 'app/business/purchase_solicitation_budget_allocation_item_status_changer'

describe PurchaseSolicitationBudgetAllocationItemStatusChanger do
  let(:item_repository) { double(:item_repository) }

  context 'when has only new_ids' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :new_item_ids => [1, 2, 3]
      )
    end

    it 'should update status to grouped' do
      item_repository.should_receive(:group!).with([1, 2, 3])

      subject.change(item_repository)
    end
  end

  context 'when has new_ids and old_ids' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :new_item_ids => [1, 2, 3],
        :old_item_ids => [1, 2, 3, 4]
      )
    end

    it 'should update status to grouped and to pending' do
      item_repository.should_receive(:group!).with([1, 2, 3])
      item_repository.should_receive(:pending!).with([4])

      subject.should_receive(:removed_item_ids).and_return([4])

      subject.change(item_repository)
    end
  end

  context 'when has only old_ids' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :old_item_ids => [1, 2, 3, 4]
      )
    end

    it 'should update status to pending' do
      item_repository.should_receive(:pending!).with([1, 2, 3, 4])

      subject.change(item_repository)
    end
  end

  context 'when have a new purchase solicitation' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :new_purchase_solicitation => purchase_solicitation)
    end

    let(:purchase_solicitation) { double(:purchase_solicitation) }

    it 'should mark all pending items as attended' do
      purchase_solicitation.should_receive(:attend_items!)

      subject.change(item_repository)
    end
  end

  context 'when have an old purchase solicitation' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :old_purchase_solicitation => purchase_solicitation)
    end

    let(:purchase_solicitation) { double(:purchase_solicitation) }

    it 'should mark all pending items as attended' do
      purchase_solicitation.should_receive(:rollback_attended_items!)

      subject.change(item_repository)
    end
  end
end
