require 'unit_helper'
require 'app/business/administrative_process_budget_allocation_cleaner'

describe AdministrativeProcessBudgetAllocationCleaner do
  context 'with item_group' do
    subject do
      AdministrativeProcessBudgetAllocationCleaner.new(
        administrative_process,
        item_group
      )
    end

    let(:administrative_process) { double(:administrative_process) }
    let(:item_group) { double(:item_group, :id => 2) }

    it 'should mark budget_allocations for destruction when item_group changes' do
      old_item_group = double(:old_item_group, :id => 2)
      budget_allocation1 = double(:budget_allocation1)
      budget_allocation2 = double(:budget_allocation2)

      administrative_process.stub(:purchase_solicitation_item_group).
      and_return(old_item_group)

      administrative_process.stub(:administrative_process_budget_allocations).
      and_return([budget_allocation1, budget_allocation2])

      budget_allocation1.should_receive(:mark_for_destruction)
      budget_allocation2.should_receive(:mark_for_destruction)

      subject.clear_old_records
    end

    it 'should not mark budget_allocations for destruction when item_group does not change' do
      budget_allocation1 = double(:budget_allocation1)
      budget_allocation2 = double(:budget_allocation2)

      administrative_process.stub(:purchase_solicitation_item_group).
      and_return(item_group)

      administrative_process.stub(:administrative_process_budget_allocations).
      and_return([budget_allocation1, budget_allocation2])

      budget_allocation1.should_not_receive(:mark_for_destruction)
      budget_allocation2.should_not_receive(:mark_for_destruction)

      subject.clear_old_records
    end
  end

  context 'without item_group' do
    subject do
      AdministrativeProcessBudgetAllocationCleaner.new(
        administrative_process,
        item_group
      )
    end

    let(:administrative_process) { double(:administrative_process) }
    let(:item_group) { nil }

    it 'should mark budget_allocations for destruction when item group is cleared' do
      old_item_group = double(:old_item_group, :id => 2)
      budget_allocation1 = double(:budget_allocation1)
      budget_allocation2 = double(:budget_allocation2)

      administrative_process.stub(:purchase_solicitation_item_group).
      and_return(old_item_group)

      administrative_process.stub(:administrative_process_budget_allocations).
      and_return([budget_allocation1, budget_allocation2])

      budget_allocation1.should_receive(:mark_for_destruction)
      budget_allocation2.should_receive(:mark_for_destruction)

      subject.clear_old_records
    end
  end
end
