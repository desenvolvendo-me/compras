# encoding: utf-8
require 'model_helper'
require 'app/models/agency'
require 'app/models/bank_account'
require 'app/models/provider'

describe Agency do
  it "return the name when call to_s" do
    subject.name = "Agência Santander"
    subject.to_s.should eq 'Agência Santander'
  end

  it "should not validate presence of email" do
    subject.valid?
    subject.errors[:email].should be_empty
  end

  it { should belong_to :city }
  it { should belong_to :bank }
  it { should have_many :bank_accounts }
  it { should have_many(:providers).dependent(:restrict) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :number }
  it { should validate_presence_of :digit }
  it { should validate_presence_of :city }
  it { should validate_presence_of :bank }

  it { should allow_value('gabriel.sobrinho@gmail.com').for(:email) }
  it { should_not allow_value('missing.host').for(:email) }
end
