# encoding: utf-8
require 'model_helper'
require 'app/models/legal_text_nature'
require 'app/models/administractive_act'

describe LegalTextNature do
  it { should validate_presence_of :description }

  it { should have_many(:administractive_acts).dependent(:restrict) }

  it "should return description as to_s method" do
    subject.description = "Natureza Cívica"

    subject.to_s.should eq "Natureza Cívica"
  end
end
