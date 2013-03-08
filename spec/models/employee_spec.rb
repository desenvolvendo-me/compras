require 'model_helper'
require 'lib/signable'
require 'app/models/employee'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/purchase_solicitation_budget_allocation_item'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_liberation'
require 'app/models/direct_purchase'
require 'app/models/licitation_process'
require 'app/models/budget_structure_responsible'
require 'app/models/price_collection'
require 'app/models/price_registration'

describe Employee do
  it { should belong_to :individual }
  it { should belong_to :position }

  it { should have_many(:contacts_of_purchase_solicitations).dependent(:restrict) }
  it { should have_many(:responsibles_of_purchase_solicitations).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_liberations).dependent(:restrict) }
  it { should have_many(:budget_structure_responsibles).dependent(:restrict) }
  it { should have_many(:direct_purchases).dependent(:restrict) }
  it { should have_many(:licitation_processes).dependent(:restrict) }
  it { should have_many(:price_collections).dependent(:restrict) }
  it { should have_many(:price_registrations).dependent(:restrict) }

  it { should validate_presence_of :individual }
  it { should validate_presence_of :registration }
  it { should validate_presence_of :position }
end
