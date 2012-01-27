require 'model_helper'
require 'app/models/entity'

describe Entity do
  it 'should return the name as to_s method' do
    subject.name = 'Denatran'
    subject.to_s.should eq 'Denatran'
  end

  it { should validate_presence_of :name }
end
