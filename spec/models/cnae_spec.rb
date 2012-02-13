# encoding: utf-8
require 'model_helper'
require 'app/models/cnae'

describe Cnae do
  it "return name when call to_s" do
    subject.name = "Produção de lavouras temporária"
    subject.to_s.should eq subject.name
  end

  it { should belong_to :risk_degree }

  it { should validate_presence_of :name }
  it { should validate_presence_of :code }

end
