# encoding: UTF-8
require 'spec_helper'

describe BudgetAllocationType do
  context 'should validate uniqueness of description' do
    before { BudgetAllocationType.make!(:administrativa) }

    it { should validate_uniqueness_of(:description) }
  end
end
