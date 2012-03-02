require 'model_helper'
require 'app/models/employee'
require 'app/models/purchase_solicitation'

describe Employee do
  it { should belong_to :person }
  it { should belong_to :position }

  it { should have_many :purchase_solicitations }
  it { should have_many(:direct_purchases).dependent(:restrict) }

  it { should validate_presence_of :person }
  it { should validate_presence_of :registration }
  it { should validate_presence_of :position }
end
