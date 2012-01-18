require 'model_helper'
require 'app/models/country'
require 'app/models/state'

describe Country do
  it 'return name when converted to string' do
    subject.name = 'Brasil'
    subject.name.should eq subject.to_s
  end

  it { should have_many(:states).dependent(:restrict)}

  it { should validate_presence_of :name }

end
