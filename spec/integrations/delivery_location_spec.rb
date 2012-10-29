# encoding: UTF-8
require 'spec_helper'

describe DeliveryLocation do
  context 'uniqueness validations' do
    before { DeliveryLocation.make!(:health) }

    it { should validate_uniqueness_of(:description) }
  end
end