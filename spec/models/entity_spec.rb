require 'model_helper'
require 'app/models/entity'
require 'app/models/expense_economic_classification'
require 'app/models/organogram_configuration'
require 'app/models/capability'
require 'app/models/government_program'
require 'app/models/government_action'
require 'app/models/pledge_historic'
require 'app/models/budget_allocation'

describe Entity do
  it 'should return the name as to_s method' do
    subject.name = 'Denatran'
    subject.to_s.should eq 'Denatran'
  end

  it { should have_many(:expense_economic_classifications).dependent(:restrict) }
  it { should have_many(:organogram_configurations).dependent(:restrict) }
  it { should have_many(:capabilities).dependent(:restrict) }
  it { should have_many(:government_programs).dependent(:restrict) }
  it { should have_many(:government_actions).dependent(:restrict) }
  it { should have_many(:pledge_historics).dependent(:restrict) }
  it { should have_many(:budget_allocations).dependent(:restrict) }
  it { should have_many(:pledges).dependent(:restrict) }
  it { should have_many(:management_units).dependent(:restrict) }

  it { should validate_presence_of :name }
end
