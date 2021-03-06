require 'model_helper'
require 'app/models/unico/occupation_classification'
require 'app/models/occupation_classification'
# require 'app/models/creditor'

describe OccupationClassification do
  it "return code and description when call to_s" do
    subject.code = '010315'
    subject.name = 'Praça da marinha'
    expect(subject.to_s).to eq "#{subject.code} - #{subject.name}"
  end

  it { should have_many(:creditors).dependent(:restrict) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :code }
end
