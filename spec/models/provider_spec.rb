# encoding: utf-8
require 'model_helper'
require 'app/models/provider'
require 'app/models/provider_partner'
require 'app/models/provider_licitation_document'
require 'app/models/direct_purchase'
require 'app/models/person'
require 'app/models/company'
require 'app/models/individual'

describe Provider do
  it { should belong_to :person }
  it { should belong_to :agency }
  it { should belong_to :legal_nature }
  it { should belong_to :cnae }
  it { should belong_to :economic_registration }
  it { should have_and_belong_to_many :materials_groups }
  it { should have_and_belong_to_many :materials_classes }
  it { should have_and_belong_to_many :materials }

  it { should have_many(:provider_partners).dependent(:destroy) }
  it { should have_many(:provider_licitation_documents).dependent(:destroy) }
  it { should have_many(:direct_purchases).dependent(:restrict) }

  it { should validate_presence_of :person }

  it 'should return the id as to_s method' do
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
