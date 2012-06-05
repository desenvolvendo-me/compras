require 'model_helper'
require 'app/models/currency'
require 'app/models/indexer'

describe Currency do
  it 'return name when converted to string' do
    subject.name = 'Real'
    subject.name.should eq subject.to_s
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :acronym }

  it { should have_many :indexers }
end
