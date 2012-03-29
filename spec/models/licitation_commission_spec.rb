# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_commission'

describe LicitationCommission do
  it { should validate_presence_of :commission_type }
  it { should validate_presence_of :nomination_date }
  it { should validate_presence_of :expiration_date }
  it { should validate_presence_of :exoneration_date }

  it 'should return id as to_s method' do
    subject.id = 2

    subject.to_s.should eq '2'
  end
end
