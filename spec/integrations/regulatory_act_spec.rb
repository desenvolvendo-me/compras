# encoding: UTF-8
require 'spec_helper'

describe RegulatoryAct do
  context 'uniqueness validations' do
    before { RegulatoryAct.make!(:sopa) }

    it { should validate_uniqueness_of(:act_number) }
    it { should validate_uniqueness_of(:content) }
  end
end