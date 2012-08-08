# encoding: utf-8
require 'model_helper'
require 'app/models/bank'
require 'app/models/agency'

describe Bank do
  it "return the name of the banck when it call to_s" do
    subject.name = 'Itaú'
    expect(subject.to_s).to eq subject.name
  end

  it "validates length of code" do
    # FIXME: it not care about others attributes
    subject.name = 'Itaú'
    subject.acronym = 'IT'

    subject.code = '87ITA'
    expect(subject).to be_valid

    subject.code = '87ITAU'
    expect(subject).to be_invalid
  end

  it { should have_many :agencies }
  it { should have_many(:bank_accounts).through(:agencies) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :code }
  it { should ensure_length_of(:code).is_at_most(5) }
end
