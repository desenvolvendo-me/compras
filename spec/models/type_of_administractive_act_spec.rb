require 'model_helper'
require 'app/models/type_of_administractive_act'
require 'app/models/administractive_act'

describe TypeOfAdministractiveAct do
  it 'should return description as to_s method' do
    subject.description = 'Lei'
    subject.to_s.should eq 'Lei'
  end

  it { should have_many(:administractive_acts).dependent(:restrict) }
  it { should belong_to :administractive_act_type_classification }

  it { should validate_presence_of :description }
  it { should validate_presence_of :administractive_act_type_classification_id }
end
