require 'model_helper'
require 'app/models/employee'

describe Employee do
  it { should belong_to :person }

  it { should validate_presence_of :person_id }
  it { should validate_presence_of :registration }
end
