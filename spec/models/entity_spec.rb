require 'model_helper'
require 'app/models/entity'
require 'app/models/expense_nature'
require 'app/models/budget_unit_configuration'
require 'app/models/capability'
require 'app/models/government_program'
require 'app/models/government_action'
require 'app/models/pledge_historic'
require 'app/models/budget_allocation'
require 'app/models/pledge'
require 'app/models/management_unit'
require 'app/models/reserve_fund'
require 'app/models/founded_debt_contract'
require 'app/models/creditor'
require 'app/models/subfunction'
require 'app/models/management_contract'
require 'app/models/extra_credit'
require 'app/models/revenue_nature'
require 'app/models/revenue_accounting'
require 'app/models/pledge_cancellation'
require 'app/models/pledge_liquidation_cancellation'
require 'app/models/subpledge'

describe Entity do
  it 'should return the name as to_s method' do
    subject.name = 'Denatran'
    subject.to_s.should eq 'Denatran'
  end

  it { should have_many(:expense_natures).dependent(:restrict) }
  it { should have_many(:budget_unit_configurations).dependent(:restrict) }
  it { should have_many(:capabilities).dependent(:restrict) }
  it { should have_many(:government_programs).dependent(:restrict) }
  it { should have_many(:government_actions).dependent(:restrict) }
  it { should have_many(:pledge_historics).dependent(:restrict) }
  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:management_units).dependent(:restrict) }
  it { should have_many(:reserve_funds).dependent(:restrict) }
  it { should have_many(:management_contracts).dependent(:restrict) }
  it { should have_many(:founded_debt_contracts).dependent(:restrict) }
  it { should have_many(:creditors).dependent(:restrict) }
  it { should have_many(:subfunctions).dependent(:restrict) }
  it { should have_many(:extra_credits).dependent(:restrict) }
  it { should have_many(:revenue_natures).dependent(:restrict) }
  it { should have_many(:revenue_accountings).dependent(:restrict) }
  it { should have_many(:pledge_cancellations).dependent(:restrict) }
  it { should have_many(:pledge_liquidation_cancellations).dependent(:restrict) }
  it { should have_many(:subpledges).dependent(:restrict) }

  it { should validate_presence_of :name }
end
