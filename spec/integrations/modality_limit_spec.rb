# encoding: UTF-8
require 'spec_helper'

describe ModalityLimit do
  context 'uniqueness validations' do
    before { ModalityLimit.make!(:modalidade_de_compra) }

    it { should validate_uniqueness_of(:ordinance_number) }
  end
end