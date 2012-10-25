# encoding: UTF-8
require 'spec_helper'

describe MaterialsClass do
  context 'uniqueness validations' do
    before { MaterialsClass.make!(:software) }

    it { should validate_uniqueness_of(:class_number).scoped_to(:materials_group_id) }
    it { should validate_uniqueness_of(:description).scoped_to(:materials_group_id) }
  end
end