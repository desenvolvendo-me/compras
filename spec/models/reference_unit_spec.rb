require 'model_helper'
require 'app/models/reference_unit'
require 'app/models/material'

describe ReferenceUnit do
  it 'return acronym when converted to string' do
    subject.acronym = 'M'
    expect(subject.to_s).to eq 'M'
  end

  it { should have_many(:materials).dependent(:restrict) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :acronym }
  it { should ensure_length_of(:acronym).is_at_most(10) }
end
