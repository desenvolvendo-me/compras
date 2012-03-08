require 'model_helper'
require 'app/models/judgment_form'
require 'app/models/bid_opening'

describe JudgmentForm do
  it 'should return description as to_s' do
    subject.description = 'Tipo principal'
    subject.to_s.should eq 'Tipo principal'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :licitation_kind }

  it { should have_many(:bid_openings).dependent(:restrict) }
end
