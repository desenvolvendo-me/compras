# encoding: utf-8
require 'model_helper'
require 'app/models/legal_reference'
require 'app/models/direct_purchase'

describe LegalReference do
  it 'should return description as to_s method' do
    subject.description = 'Referencia legal'

    subject.to_s.should eq 'Referencia legal'
  end

  it { should validate_presence_of :description }
  it { should validate_presence_of :law }
  it { should validate_presence_of :article }

  it { should validate_numericality_of :law }
  it { should validate_numericality_of :article }
  it { should validate_numericality_of :paragraph }

  it { should have_many(:direct_purchases).dependent(:restrict) }
end
