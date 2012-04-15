require 'model_helper'
require 'app/models/employee'
require 'app/models/purchase_solicitation'
require 'app/models/direct_purchase'
require 'app/models/administrative_process'
require 'app/models/budget_unit_responsible'

describe Employee do
  it { should belong_to :person }
  it { should belong_to :position }

  it { should have_many(:purchase_solicitations).dependent(:restrict) }
  it { should have_many(:budget_unit_responsibles).dependent(:restrict) }
  it { should have_many(:direct_purchases).dependent(:restrict) }
  it { should have_many(:administrative_processes).dependent(:restrict) }

  it { should validate_presence_of :person }
  it { should validate_presence_of :registration }
  it { should validate_presence_of :position }
end
