require 'model_helper'
require 'app/models/materials_group'
require 'app/models/state'


describe MaterialsGroup do
  it { should validate_presence_of :group }
  it { should validate_presence_of :name }
end
