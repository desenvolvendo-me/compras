# encoding: utf-8
require 'model_helper'
require 'app/models/materials_control'

describe MaterialsControl do
  it { should belong_to(:material) }
  it { should belong_to(:warehouse) }
end
