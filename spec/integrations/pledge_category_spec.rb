# encoding: UTF-8
require 'spec_helper'

describe PledgeCategory do
  context 'uniqueness validations' do
    before { PledgeCategory.make!(:geral) }

    it { should validate_uniqueness_of(:description)}
  end
end