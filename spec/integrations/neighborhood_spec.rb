# encoding: UTF-8
require 'spec_helper'

describe Neighborhood do
  context 'uniqueness validations' do
    before { Neighborhood.make!(:portugal) }

    it { should validate_uniqueness_of(:name).scoped_to(:district_id, :city_id) }
  end
end