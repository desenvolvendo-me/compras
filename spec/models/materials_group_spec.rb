require 'spec_helper'

describe MaterialsGroup do
  it { should validate_presence_of :group }
  it { should validate_presence_of :name }
end
