# encoding: UTF-8
require 'spec_helper'

describe BudgetAllocation do
  context 'uniqueness validations' do
    before { BudgetAllocation.make!(:alocacao) }

    it { should validate_uniqueness_of(:description) }
    it { should validate_uniqueness_of(:code).scoped_to(:descriptor_id) }
  end
end