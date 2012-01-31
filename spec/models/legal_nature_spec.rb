# encoding: utf-8
require 'model_helper'
require 'app/models/legal_nature'
require 'app/models/administration_type'

describe LegalNature do
  it "return the name when call to_s" do
    subject.name = 'Administração Pública'
    subject.to_s.should eq subject.name
  end

  it { should have_many :administration_types }

  it { should validate_presence_of :name }
  it { should validate_presence_of :code }

end
