require 'unit_helper'
require 'active_support/core_ext/object/blank'
require 'app/business/administrative_process_item_group_cloner'

describe AdministrativeProcessItemGroupCloner do
  let(:budget_allocation_cloner) { double(:budget_allocation_cloner) }
  let(:licitation_process) { double(:licitation_process) }

  describe '#clone!' do
    context 'without licitation process' do
      subject do
        described_class.new(nil,
          :budget_allocation_cloner => budget_allocation_cloner)
      end

      it 'should do nothing' do
        budget_allocation_cloner.should_not_receive(:clone)

        subject.clone!
      end
    end

    context 'with licitation process' do
      context 'when old and new item group are the same' do
        subject do
          described_class.new(licitation_process,
            :budget_allocation_cloner => budget_allocation_cloner)
        end

        it 'should do nothing when old and new item group are the same' do
          budget_allocation_cloner.should_not_receive(:clone)

          subject.clone!
        end
      end

      context 'when old and new item group are different' do
        let(:adm_budget_allocations) { double(:administrative_process_budget_allocations) }
        let(:purchase_solicitation) { double(:purchase_solicitation) }
        let(:material) { double(:material) }

        let(:item_group_material) do
          double(:item_group_material,
            :purchase_solicitations => [purchase_solicitation],
            :material => material)
        end

        let(:new_item_group) do
          double(:new_item_group,
            :purchase_solicitation_item_group_materials => [item_group_material])
        end

        subject do
          described_class.new(licitation_process,
            :budget_allocation_cloner => budget_allocation_cloner,
            :new_item_group => new_item_group)
        end

        it 'should clone budget allocations for all budget allocations of that material' do
          licitation_process.stub(:administrative_process_budget_allocations => adm_budget_allocations)
          adm_budget_allocations.should_receive(:destroy_all)

          budget_allocation_cloner.
            should_receive(:clone).
            with(:licitation_process => licitation_process,
                 :new_purchase_solicitation => purchase_solicitation,
                 :material => material,
                 :clear_old_data => false)

          subject.clone!
        end
      end
    end
  end

  describe ".clone" do
    let(:instance) { double(:instance) }

    it 'should instantiate and call #clone!' do
      described_class.should_receive(:new).with(licitation_process).and_return(instance)
      instance.should_receive(:clone!)

      described_class.clone(licitation_process)
    end
  end
end
