# encoding: UTF-8
require 'spec_helper'

describe BudgetRevenue do
  context 'uniqueness validations' do
    before { BudgetRevenue.make!(:reforma) }

    it { should validate_uniqueness_of(:revenue_nature_id) }
    it { should validate_uniqueness_of(:code).scoped_to(:descriptor_id) }
  end
end