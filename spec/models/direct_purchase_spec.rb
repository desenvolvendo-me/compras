# encoding: utf-8
require 'model_helper'
require 'app/models/direct_purchase'

describe DirectPurchase do
  it 'should return id as to_s method' do
    subject.id = 1

    subject.to_s.should eq '1'
  end

  it { should belong_to :legal_reference }
  it { should belong_to :provider }
  it { should belong_to :organogram }
  it { should belong_to :licitation_object }
  it { should belong_to :delivery_location }
  it { should belong_to :employee }
  it { should belong_to :payment_method }
  it { should belong_to :period }
end
