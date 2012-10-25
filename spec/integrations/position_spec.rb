# encoding: UTF-8
require 'spec_helper'

describe Position do
  context 'uniqueness validations' do
    before { Position.make!(:gerente) }

    it { should validate_uniqueness_of(:name) }
  end
end