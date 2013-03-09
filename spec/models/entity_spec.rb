require 'model_helper'
require 'app/models/entity'
require 'app/models/budget_structure_configuration'
require 'app/parsers/month_and_year_parser'
require 'app/models/descriptor'

describe Entity do
  it 'should return the name as to_s method' do
    subject.name = 'Denatran'
    expect(subject.to_s).to eq 'Denatran'
  end

  it { should have_many(:budget_structure_configurations).dependent(:restrict) }
  it { should have_many(:descriptors).dependent(:restrict) }

  it { should validate_presence_of :name }
end
