# encoding: utf-8
require 'model_helper'
require 'app/models/legal_texts_nature'

describe LegalTextsNature do
  it { should validate_presence_of :name }

  it { should have_many :administractive_acts }

  it "should return name as to_s method" do
    subject.name = "Natureza Cívica"

    subject.to_s.should eq "Natureza Cívica"
  end
end
