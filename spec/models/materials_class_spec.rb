require 'model_helper'
require 'app/models/materials_group'
require 'app/models/materials_class'

describe MaterialsClass do
  it { should belong_to :materials_group }

  it { should validate_presence_of :class_number }
  it { should validate_presence_of :name }

  it { should allow_value("01").for(:class_number) }
  it { should_not allow_value("ab").for(:class_number) }
  it { should_not allow_value("1").for(:class_number) }
  it { should_not allow_value("001").for(:class_number) }

  it 'should return class_number and name as to_s method' do
    subject.class_number = '01'
    subject.name = 'Hortifrutigranjeiros'

    subject.to_s.should eq '01 - Hortifrutigranjeiros'
  end
end
