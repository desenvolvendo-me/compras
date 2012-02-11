require 'model_helper'
require 'app/models/reference_unit'
require 'app/models/material'

describe ReferenceUnit do
  it 'return name when converted to string' do
    subject.name = 'Unidade'
    subject.name.should eq subject.to_s
  end

  it 'validates length of acronym' do
    # FIXME: it not care about others attributes
    subject.name = 'Unidade'

    subject.acronym = 'UN'
    subject.should be_valid

    subject.acronym = 'UNI'
    subject.should be_invalid

    subject.acronym = 'U'
    subject.should be_valid
  end

  it { should have_many(:materials).dependent(:restrict) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :acronym }
  it { should ensure_length_of(:acronym).is_at_most(2) }

end
