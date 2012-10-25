# encoding: UTF-8
require 'spec_helper'

describe ExpenseKind do
  context 'uniqueness validations' do
    before { ExpenseKind.make!(:pagamentos) }

    it { should validate_uniqueness_of(:description) }
  end
end