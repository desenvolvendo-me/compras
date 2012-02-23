require 'model_helper'
require 'app/models/materials_type'

describe MaterialsType do
  it 'should return to_s as description' do
    subject.description = 'Casa'
    subject.to_s.should eq 'Casa'
  end

  it { should validate_presence_of :description }
end
