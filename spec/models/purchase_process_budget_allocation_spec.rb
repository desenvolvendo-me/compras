require 'model_helper'
require 'app/models/budget_structure'
require 'app/models/expense_nature'
require 'app/models/budget_allocation'
require 'app/models/material'
require 'app/models/purchase_process_budget_allocation'

describe PurchaseProcessBudgetAllocation do
  let :budget_allocation_params do
    { params:
         { includes: [
           :expense_nature,
           { budget_structure: { except: :custom_data },
             budget_allocation_capabilities: { include: {
             capability: {
               only: :id,
               methods: [
                 :capability_source_code
               ]
             },
             budget_allocation: {
               include: {
                 budget_structure: {
                   methods: [
                     :structure_sequence
                   ]
                 }
               },
               methods: [
                 :expense_nature_expense_nature,
                 :function_code,
                 :subfunction_code,
                 :government_program_code,
                 :government_action_code,
                 :government_action_action_type,
                 :amount
               ]
             }
           }}
          }
        ],
        methods: [
          :balance,
          :amount,
          :budget_structure_structure_sequence,
        ]
      }
    }
  end

  it { should belong_to :licitation_process }

  it { should validate_presence_of :budget_allocation_id }
  it { should validate_presence_of :value }

  it { should delegate(:expense_nature).to(:budget_allocation).allowing_nil(true).prefix(true) }
  it { should delegate(:expense_nature_id).to(:budget_allocation).allowing_nil(true).prefix(true) }
  it { should delegate(:amount).to(:budget_allocation).allowing_nil(true).prefix(true) }
  it { should delegate(:descriptor_id).to(:budget_allocation).allowing_nil(true).prefix(true) }

  it 'should belong to resource budget_allocation' do
    budget_allocation = BudgetAllocation.new(id: 2)

    subject.budget_allocation_id = 2

    BudgetAllocation.should_receive(:find).with(2, budget_allocation_params).and_return(budget_allocation)

    expect(subject.budget_allocation).to be budget_allocation
  end

  describe 'block_when_budget_allocation_used' do
    context 'when has no budget_allocation_id' do
      it 'should do nothing' do
        subject.destroy

        expect(subject.errors[:budget_allocation]).to_not include('já está reservada ou empenhada')
      end
    end

    context 'when has budget_allocation_id' do
      let(:budget_allocation) { double(:budget_allocation) }

      before do
        subject.stub(budget_allocation_id: 10)
      end

      context 'when budget_allocation can be used' do
        it 'should do nothing' do
          subject.stub(:budget_allocation).and_return(budget_allocation)
          budget_allocation.stub(can_be_used?: true)

          subject.destroy

          expect(subject.errors[:budget_allocation]).to_not include('já está reservada ou empenhada')
        end
      end

      context 'when budget_allocation cannot be used' do
        it 'should do nothing' do
          subject.stub(:budget_allocation).and_return(budget_allocation)
          budget_allocation.stub(can_be_used?: false)

          subject.destroy

          expect(subject.errors[:budget_allocation]).to include('já está reservada ou empenhada')
        end
      end
    end
  end

  describe 'validate_budget_allocation' do
    context 'when has no budget_allocation_id' do
      it 'should do nothing' do
        subject.valid?

        expect(subject.errors[:budget_allocation]).to_not include('já está reservada ou empenhada')
      end
    end

    context 'when has a budget_allocation_id' do
      let(:budget_allocation) { double(:budget_allocation) }

      before do
        subject.stub(budget_allocation_id: 5)
        subject.stub(budget_allocation: budget_allocation)
      end

      context 'when budget_allocation_id was not changed' do
        it 'should do nothing' do
          subject.valid?

          expect(subject.errors[:budget_allocation]).to_not include('já está reservada ou empenhada')
        end
      end

      context 'when budget_allocation_id changed' do
        let(:old_budget_allocation) { double(:old_budget_allocation) }

        before do
          subject.stub(:validation_context).and_return(:update)
        end

        context 'when old cannot be used' do
          it 'should add an error' do
            subject.stub(changed_attributes: { 'budget_allocation_id' => 10 })
            subject.stub(old_budget_allocation_id: 5)

            BudgetAllocation.
              should_receive(:find).
              with(5).
              and_return(old_budget_allocation)

            old_budget_allocation.stub(can_be_used?: false)

            subject.valid?

            expect(subject.errors[:budget_allocation]).to include('já está reservada ou empenhada')
          end
        end

        context 'when old can be used but the new one not' do
          it 'should add an error' do
            subject.stub(:changed_attributes => { 'budget_allocation_id' => 10 })
            subject.stub(old_budget_allocation_id: 5)

            BudgetAllocation.
              should_receive(:find).
              with(5).
              and_return(old_budget_allocation)

            old_budget_allocation.stub(can_be_used?: true)

            subject.valid?

            expect(subject.errors[:budget_allocation]).to_not include('já está reservada ou empenhada')
          end
        end
      end
    end
  end
end
