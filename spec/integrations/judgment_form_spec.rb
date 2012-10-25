# encoding: UTF-8
require 'spec_helper'

describe JudgmentForm do
  context 'uniqueness validations' do
    before { JudgmentForm.make!(:global_com_menor_preco) }

    it { should validate_uniqueness_of(:description) }
  end
end