# encoding: utf-8
require 'model_helper'
require 'app/models/regulatory_act_type'
require 'app/models/legal_text_nature'
require 'app/models/regulatory_act'

describe LegalTextNature do
  it { should validate_presence_of :description }

  it { should have_many(:regulatory_acts).dependent(:restrict) }

  it "should return description as to_s method" do
    subject.description = "Natureza Cívica"

    expect(subject.to_s).to eq "Natureza Cívica"
  end
end
