# encoding: utf-8
require 'model_helper'
require 'app/models/payment_method'
require 'app/models/licitation_process'
require 'app/models/price_collection'

describe PaymentMethod do
  it 'should return description as to_s method' do
    subject.description = 'Dinheiro'

    expect(subject.to_s).to eq 'Dinheiro'
  end

  it { should have_many(:licitation_processes).dependent(:restrict) }
  it { should have_many(:price_collections).dependent(:restrict) }
end
