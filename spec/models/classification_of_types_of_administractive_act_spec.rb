require 'spec_helper'

describe ClassificationOfTypesOfAdministractiveAct do
  it 'should return description as to_s method' do
    subject.description = 'Classification of Types'
    subject.to_s.should eq 'Classification of Types'
  end

  it { should validate_presence_of(:description) }
end
