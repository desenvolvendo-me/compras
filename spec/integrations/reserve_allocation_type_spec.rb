# encoding: UTF-8
require 'spec_helper'

describe ReserveAllocationType do
  context 'uniqueness validations' do
    before { ReserveAllocationType.make!(:comum) }

    it {should validate_uniqueness_of(:description) }
  end
end