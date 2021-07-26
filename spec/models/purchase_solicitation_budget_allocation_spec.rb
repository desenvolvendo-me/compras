# require 'model_helper'
# require 'app/models/expense_nature'
# require 'app/models/budget_allocation'
# require 'app/models/purchase_solicitation_budget_allocation'
#
# describe PurchaseSolicitationBudgetAllocation do
#   describe 'default values' do
#     it 'uses false as default for blocked' do
#       expect(subject.blocked).to be false
#     end
#   end
#
#   it { should delegate(:services?).to(:purchase_solicitation).allowing_nil(true) }
#   it { should delegate(:expense_nature).to(:budget_allocation).allowing_nil(true).prefix(true) }
#   it { should delegate(:balance).to(:budget_allocation).allowing_nil(true).prefix(true) }
#
#   it { should validate_presence_of :budget_allocation_id }
#
#   it { should belong_to :purchase_solicitation }
#
#   it "should have false as the default value of blocked" do
#     expect(subject.blocked).to eq false
#   end
#
#   it 'should belong to resource budget_allocation' do
#     budget_allocation = BudgetAllocation.new(id: 2)
#     params = { params: { includes: :expense_nature, methods: :balance} }
#
#     subject.budget_allocation_id = 2
#
#     BudgetAllocation.should_receive(:find).with(2, params).and_return(budget_allocation)
#
#     expect(subject.budget_allocation).to be budget_allocation
#   end
# end
