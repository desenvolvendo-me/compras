# encoding: UTF-8
require 'spec_helper'

describe SpecialEntry do
  context 'uniqueness validations' do
    before { SpecialEntry.make!(:example) }

    it { should validate_uniqueness_of(:name) }
  end
end