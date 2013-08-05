# encoding: utf-8
require 'model_helper'
require 'app/models/budget_structure'
require 'app/models/expense_nature'
require 'app/models/budget_allocation'
require 'app/models/material'
require 'app/models/purchase_process_budget_allocation'

describe PurchaseProcessBudgetAllocation do
  it { should belong_to :licitation_process }

  it { should validate_presence_of :budget_allocation_id }
  it { should validate_presence_of :value }

  it { should delegate(:expense_nature).to(:budget_allocation).allowing_nil(true).prefix(true) }
  it { should delegate(:expense_nature_id).to(:budget_allocation).allowing_nil(true).prefix(true) }
  it { should delegate(:amount).to(:budget_allocation).allowing_nil(true).prefix(true) }
  it { should delegate(:descriptor_id).to(:budget_allocation).allowing_nil(true).prefix(true) }

  it 'should belong to resource budget_allocation' do
    budget_allocation = BudgetAllocation.new(id: 2)
    params = { params:
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

    subject.budget_allocation_id = 2

    BudgetAllocation.should_receive(:find).with(2, params).and_return(budget_allocation)

    expect(subject.budget_allocation).to be budget_allocation
  end
end
