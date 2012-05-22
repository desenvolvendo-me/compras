# encoding: utf-8
require 'model_helper'
require 'app/models/payment_method'
require 'app/models/direct_purchase'
require 'app/models/licitation_process'

describe PaymentMethod do
  it 'should return description as to_s method' do
    subject.description = 'Dinheiro'

    subject.to_s.should eq 'Dinheiro'
  end

  it { should have_many(:direct_purchases).dependent(:restrict) }
  it { should have_many(:licitation_processes).dependent(:restrict) }
  it { should have_many(:price_collections).dependent(:restrict) }
end
