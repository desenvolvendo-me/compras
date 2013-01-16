require 'unit_helper'
require 'app/business/purchase_solicitation_budget_allocation_item_status_changer'

describe PurchaseSolicitationBudgetAllocationItemStatusChanger do
  let(:item_repository) { double(:item_repository) }
  let(:direct_purchase) { double(:direct_purchase, :id => 1, :class_name => 'DirectPurchase') }
  let(:administrative_process) { double(:administrative_process, :id => 1, :class_name => 'AdministrativeProcess') }
  let(:purchase_solicitation) { double(:purchase_solicitation) }
  let(:purchase_solicitation_item_group) { double(:purchase_solicitation_item_group) }
  let(:items) { double(:items) }

  context 'when has only new_ids' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :new_item_ids => [1, 2, 3],
        :purchase_solicitation_item_group_id => 1
      )
    end

    it 'should update status to grouped' do
      item_repository.should_receive(:group_by_ids!).with([1, 2, 3], 1)

      subject.change(item_repository)
    end
  end

  context 'when has new_ids and old_ids' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :new_item_ids => [1, 2, 3],
        :old_item_ids => [1, 2, 3, 4],
        :purchase_solicitation_item_group_id => 1
      )
    end

    it 'should update status to grouped and to pending' do
      item_repository.should_receive(:group_by_ids!).with([1, 2, 3], 1)
      item_repository.should_receive(:pending_by_ids!).with([4])

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
      item_repository.should_receive(:pending_by_ids!).with([1, 2, 3, 4])

      subject.change(item_repository)
    end
  end

  context 'when have a new purchase solicitation' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :new_purchase_solicitation => purchase_solicitation)
    end

    context 'when purchase solicitation is from direct purchase' do
      before do
        purchase_solicitation.should_receive(:direct_purchase).twice.and_return(direct_purchase)
        purchase_solicitation.should_receive(:administrative_process).and_return(nil)
      end

      it 'should mark all items from direct purchase as attended' do
        purchase_solicitation.should_receive(:direct_purchase_authorized?).and_return(true)
        direct_purchase.should_receive(:attend_purchase_solicitation_items)

        subject.change(item_repository)
      end
    end

    context 'when purchase solicitation is from direct purchase' do
      before do
        purchase_solicitation.should_receive(:direct_purchase).once.and_return(nil)
        purchase_solicitation.should_receive(:administrative_process).twice.and_return(administrative_process)
      end

      it 'should mark all pending items from administrative process as attended' do
        purchase_solicitation.should_receive(:direct_purchase_authorized?).and_return(true)
        administrative_process.should_receive(:attend_purchase_solicitation_items)

        subject.change(item_repository)
      end
    end
  end

  context 'when have an old purchase solicitation from direct purchase' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :old_purchase_solicitation => purchase_solicitation,
        :direct_purchase => direct_purchase)
    end

    it 'should mark all items from direct purchase as attended' do
      items = double(:items)
      item_repository.should_receive(:by_fulfiller).with(direct_purchase.id, direct_purchase.class.name).and_return(items)
      items.should_receive(:pending!)

      subject.change(item_repository)
    end
  end

  context 'when have an old purchase solicitation from admnistrative process' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :old_purchase_solicitation => purchase_solicitation,
        :administrative_process => administrative_process)
    end

    it 'should mark all items from administrative process as attended' do
      item_repository.should_receive(:by_fulfiller).with(administrative_process.id, administrative_process.class.name).and_return(items)
      items.should_receive(:pending!)

      subject.change(item_repository)
    end
  end

  context 'when have a purchase solicitation item group from direct purchase' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :new_purchase_solicitation_item_group => purchase_solicitation_item_group)
    end

    it 'should mark all items from item group as attended when direct purchase is authorized' do
      purchase_solicitation_item_group.should_receive(:direct_purchase_authorized?).and_return(true)

      item_repository.should_receive(:by_item_group).with(purchase_solicitation_item_group).and_return(items)
      items.should_receive(:attend!)

      subject.change(item_repository)
    end

    it 'should mark all items from item group as partially fulfilled when direct purchase is not authorized' do
      purchase_solicitation_item_group.should_receive(:direct_purchase_authorized?).and_return(false)

      item_repository.should_receive(:by_item_group).with(purchase_solicitation_item_group).and_return(items)
      items.should_receive(:partially_fulfilled!)

      subject.change(item_repository)
    end
  end

  context 'when have an old purchase solicitation item group' do
    subject do
      PurchaseSolicitationBudgetAllocationItemStatusChanger.new(
        :old_purchase_solicitation_item_group => purchase_solicitation_item_group)
    end

    it 'should mark all items from old item group as pending' do
      item_repository.should_receive(:by_item_group).with(purchase_solicitation_item_group).and_return(items)
      items.should_receive(:pending!)

      subject.change(item_repository)
    end
  end
end
