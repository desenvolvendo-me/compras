require 'model_helper'
require 'app/models/materials_group'
require 'app/models/materials_class'

describe MaterialsClass do
  it { should belong_to :materials_group }

  it { should validate_presence_of :name }

  it 'should return name as to_s method' do
    subject.name = 'Hortifrutigranjeiros'
    subject.to_s.should eq 'Hortifrutigranjeiros'
  end
end
