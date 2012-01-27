require 'model_helper'
require 'app/models/type_of_administractive_act'

describe TypeOfAdministractiveAct do
  it 'should return name as to_s method' do
    subject.name = 'Lei'
    subject.to_s.should eq 'Lei'
  end

  it { should validate_presence_of :name }
end
