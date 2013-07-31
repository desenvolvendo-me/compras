# encoding: UTF-8
require 'spec_helper'

describe PaymentMethod do
  context 'uniqueness validations' do
    before { PaymentMethod.make!(:dinheiro) }

    it { should validate_uniqueness_of(:description) }
  end
end