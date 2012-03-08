require 'model_helper'
require 'app/models/judgment_form'

describe JudgmentForm do
  it 'should return description as to_s' do
    subject.description = 'Tipo principal'
    subject.to_s.should eq 'Tipo principal'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :licitation_kind }
end
