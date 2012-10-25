# encoding: UTF-8
require 'spec_helper'

describe Entity do
  context 'uniqueness validations' do
    before { Entity.make!(:detran) }

    it { should validate_uniqueness_of(:name) }
  end
end