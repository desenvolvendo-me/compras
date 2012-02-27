require 'model_helper'
require 'app/models/position'

describe Position do
  it 'should return name as to_s' do
    subject.name = 'Gerente'
    subject.to_s.should eq 'Gerente'
  end

  it { should validate_presence_of :name }
end
