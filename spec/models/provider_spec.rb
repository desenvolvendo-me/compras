# encoding: utf-8
require 'model_helper'
require 'app/models/provider'

describe Provider do
  it { should belong_to :person }
  it { should belong_to :agency }
  it { should belong_to :legal_nature }
  it { should belong_to :cnae }
  it { should belong_to :economic_registration }

  it { should have_many(:provider_partners).dependent(:destroy) }

  it { should validate_presence_of :person }

  it 'should return person as to_s method' do
    subject.id = 1

    subject.to_s.should eq '1'
  end

  it "should have partners with the same individual invalid except the first" do
    partner_one = subject.provider_partners.build(:individual_id => 1)
    partner_two = subject.provider_partners.build(:individual_id => 1)

    subject.valid?

    partner_one.errors.messages[:individual_id].should be_nil
    partner_two.errors.messages[:individual_id].should include "já está em uso"
  end

  it "should have partners with different individual valid" do
    partner_one = subject.provider_partners.build(:individual_id => 1)
    partner_two = subject.provider_partners.build(:individual_id => 2)

    subject.valid?

    partner_one.errors.messages[:individual_id].should be_nil
    partner_two.errors.messages[:individual_id].should be_nil
  end
end
