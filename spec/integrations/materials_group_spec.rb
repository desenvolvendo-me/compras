# encoding: UTF-8
require 'spec_helper'

describe MaterialsGroup do
  context 'uniqueness validations' do
    before { MaterialsGroup.make!(:informatica) }

    it { should validate_uniqueness_of(:group_number) }
    it { should validate_uniqueness_of(:description)  }
  end
end