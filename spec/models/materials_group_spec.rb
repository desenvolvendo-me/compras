require 'model_helper'
require 'app/models/materials_group'
require 'app/models/materials_class'

describe MaterialsGroup do
  it 'should return group followed by name on to_s method' do
    subject.group_number = '01'
    subject.description = 'Grupo de materiais'

    subject.to_s.should eq("01 - Grupo de materiais")
  end

  it { should have_many(:materials_classes).dependent(:restrict) }
  it { should have_and_belong_to_many :providers }

  it { should validate_presence_of :group_number }
  it { should validate_numericality_of :group_number }
  it { should validate_presence_of :description }

  it { should_not allow_value('a2').for(:group_number) }
  it { should_not allow_value('902').for(:group_number) }
  it { should allow_value('02').for(:group_number) }
end
