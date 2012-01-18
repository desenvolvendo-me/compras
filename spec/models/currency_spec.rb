require 'model_helper'
require 'app/models/currency'

describe Currency do
  it 'return name when converted to string' do
    subject.name = 'Real'
    subject.name.should eq subject.to_s
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :acronym }

end
