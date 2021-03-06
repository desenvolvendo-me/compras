require 'model_helper'
require 'lib/signable'
require 'app/models/judgment_form'
require 'app/models/licitation_process'

describe JudgmentForm do
  it 'should return description as to_s' do
    subject.description = 'Tipo principal'
    expect(subject.to_s).to eq 'Tipo principal'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :kind }
  it { should validate_presence_of :licitation_kind }

  it { should have_many(:licitation_processes).dependent(:restrict) }
end
