require 'model_helper'
require 'app/models/issqn_classification'

describe IssqnClassification do
  it 'return name when converted to string' do
    subject.name = 'Fixo anual'
    subject.name.should eq subject.to_s
  end

  it { should validate_presence_of :name }

end
