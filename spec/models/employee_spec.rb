require 'model_helper'
require 'app/models/employee'
require 'app/models/purchase_solicitation'

describe Employee do
  it { should belong_to :person }
  it { should have_many :purchase_solicitations }

  it { should validate_presence_of :person_id }
  it { should validate_presence_of :registration }
end
