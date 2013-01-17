require 'unit_helper'
require 'app/business/administrative_process_budget_allocation_cloner'

describe AdministrativeProcessBudgetAllocationCloner do
  subject do
    described_class.new(:administrative_process => administrative_process,
                        :new_purchase_solicitation => purchase_solicitation)
  end

  let(:administrative_process) { double(:administrative_process) }
  let(:purchase_solicitation) { double(:purchase_solicitation) }

  describe 'delegates' do
    it 'should delegates purchase_solicitation_budget_allocations to purchase_solicitation' do
      purchase_solicitation.should_receive(:purchase_solicitation_budget_allocations)

      subject.purchase_solicitation_budget_allocations
    end
  end

  describe '#clone!' do
    context 'when has no purchase_solicitation' do
      subject do
        described_class.new(:administrative_process => administrative_process)
      end

      it 'should do nothing' do
        subject.should_not_receive(:clone_budget_allocation)

        subject.clone!
      end
    end

    context 'when has only new_purchase_solicitation' do
      subject do
        described_class.new(:new_purchase_solicitation => purchase_solicitation)
      end

      it 'should do nothing' do
        subject.should_not_receive(:clone_budget_allocation)

        subject.clone!
      end
    end

    context 'when has only old_purchase_solicitation' do
      subject do
        described_class.new(:oldq_purchase_solicitation => purchase_solicitation)
      end

      it 'should do nothing' do
        subject.should_not_receive(:clone_budget_allocation)

        subject.clone!
      end
    end

    context 'with administrative_process and purchase_solicitations' do
      let(:adm_budget_allocations) { double(:administrative_process_budget_allocations) }
      let(:adm_items) { double(:administrative_process_budget_allocation_items) }
      let(:adm_item) { double(:administrative_process_budget_allocation_item) }

      let(:adm_budget_allocation) do
        double(:administrative_process_budget_allocation, :items => adm_items)
      end

      let(:pur_item) do
        double(:purchase_solicitation_budget_allocation_item, :material_id => 4,
               :quantity => 10, :unit_price => 50.5)
      end

      let(:budget_allocation) do
        double(:budget_allocation ,:budget_allocation_id => 1,
               :total_items_value => 100, :items => [pur_item])
      end

      before do
        purchase_solicitation.stub(:purchase_solicitation_budget_allocations => [budget_allocation])
        administrative_process.stub(:administrative_process_budget_allocations => adm_budget_allocations)
      end

      describe 'with new_purchase_solicitation different from old_purchase_solicitation' do
        it 'should copy the budget_allocations from purchase_solicitation to administrative_process' do
          adm_budget_allocations.should_receive(:destroy_all)
          adm_budget_allocations.should_receive(:build).and_return(adm_budget_allocation)
          adm_items.should_receive(:build).and_return(adm_item)

          adm_budget_allocation.should_receive(:transaction).and_yield
          adm_budget_allocation.should_receive(:budget_allocation_id=).with(1)
          adm_budget_allocation.should_receive(:value=).with(100)
          adm_budget_allocation.should_receive(:save!)

          adm_item.should_receive(:material_id=).with(4)
          adm_item.should_receive(:quantity=).with(10)
          adm_item.should_receive(:unit_price=).with(50.5)
          adm_item.should_receive(:save!)

          subject.clone!
        end
      end

      describe 'with new_purchase_solicitation equals to old_purchase_solicitation' do
        subject do
          described_class.new(:administrative_process => administrative_process,
                              :new_purchase_solicitation => purchase_solicitation,
                              :old_purchase_solicitation => purchase_solicitation)
        end

        it 'should do nothing' do
          subject.should_not_receive(:clone_budget_allocation)
          adm_budget_allocations.should_not_receive(:destroy_all)

          subject.clone!
        end
      end

      context 'with material' do
        let(:material) { double(:material, :id => 34) }
        let(:items) { double(:items) }

        let(:budget_allocation) do
          double(:budget_allocation ,:budget_allocation_id => 1,
                 :total_items_value => 100, :items => items)
        end

        subject do
          described_class.new(:administrative_process => administrative_process,
                              :new_purchase_solicitation => purchase_solicitation,
                              :material => material)
        end

        it 'should copy the budget_allocations only with specific material from purchase_solicitation to administrative_process' do
          adm_budget_allocations.should_receive(:destroy_all)
          adm_budget_allocations.should_receive(:build).and_return(adm_budget_allocation)
          adm_items.should_receive(:build).and_return(adm_item)
          items.should_receive(:by_material).with(34).and_return([pur_item])

          adm_budget_allocation.should_receive(:transaction).and_yield
          adm_budget_allocation.should_receive(:budget_allocation_id=).with(1)
          adm_budget_allocation.should_receive(:value=).with(100)
          adm_budget_allocation.should_receive(:save!)

          adm_item.should_receive(:material_id=).with(4)
          adm_item.should_receive(:quantity=).with(10)
          adm_item.should_receive(:unit_price=).with(50.5)
          adm_item.should_receive(:save!)

          subject.clone!
        end
      end

      context 'without clear_old_data' do
        subject do
          described_class.new(:administrative_process => administrative_process,
                              :new_purchase_solicitation => purchase_solicitation,
                              :clear_old_data => false)
        end

        it 'should copy the budget_allocations from purchase_solicitation to administrative_process without clear old data' do
          adm_budget_allocations.should_not_receive(:destroy_all)
          adm_budget_allocations.should_receive(:build).and_return(adm_budget_allocation)
          adm_items.should_receive(:build).and_return(adm_item)

          adm_budget_allocation.should_receive(:transaction).and_yield
          adm_budget_allocation.should_receive(:budget_allocation_id=).with(1)
          adm_budget_allocation.should_receive(:value=).with(100)
          adm_budget_allocation.should_receive(:save!)

          adm_item.should_receive(:material_id=).with(4)
          adm_item.should_receive(:quantity=).with(10)
          adm_item.should_receive(:unit_price=).with(50.5)
          adm_item.should_receive(:save!)

          subject.clone!
        end
      end
    end
  end
end
