require 'model_helper'
require 'app/models/company_size'
require 'app/models/company'

describe CompanySize do
  it "return name when call to_s" do
    subject.name = "Empresa de grande porte"
    subject.to_s.should eq subject.name
  end

  it { should have_many(:companies).dependent(:restrict) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :acronym }
end
