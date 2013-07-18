# encoding: utf-8
require 'model_helper'
require 'app/models/agency'

describe Agency do
  it "return the name when call to_s" do
    subject.name = "Agência Santander"
    expect(subject.to_s).to eq 'Agência Santander'
  end

  it "should not validate presence of email" do
    subject.valid?
    expect(subject.errors[:email]).to be_empty
  end

  it { should belong_to :bank }

  it { should validate_presence_of :name }
  it { should validate_presence_of :number }
  it { should validate_presence_of :digit }
  it { should validate_presence_of :bank }

  it { should allow_value('gabriel.sobrinho@gmail.com').for(:email) }
  it { should_not allow_value('missing.host').for(:email) }
end
