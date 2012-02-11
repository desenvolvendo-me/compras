require 'model_helper'
require 'app/models/entity'
require 'app/models/economic_classification_of_expenditure'
require 'app/models/organogram_configuration'

describe Entity do
  it 'should return the name as to_s method' do
    subject.name = 'Denatran'
    subject.to_s.should eq 'Denatran'
  end

  it { should have_many(:economic_classification_of_expenditures).dependent(:restrict) }
  it { should have_many(:organogram_configurations).dependent(:restrict) }

  it { should validate_presence_of :name }
end
