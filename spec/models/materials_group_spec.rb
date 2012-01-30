require 'model_helper'
require 'app/models/materials_group'

describe MaterialsGroup do
  it 'should return group followed by name on to_s method' do
    subject.group = '01'
    subject.name = 'Grupo de materiais'

    subject.to_s.should eq("01 - Grupo de materiais")
  end

  it { should validate_presence_of :group }
  it { should validate_presence_of :name }
end
