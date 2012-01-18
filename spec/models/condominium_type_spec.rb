require 'model_helper'
require 'app/models/condominium_type'
require 'config/initializers/inflections'
require 'app/models/condominium'

describe CondominiumType do
  it "return name when converted to a string" do
    subject.name = "Vertical"
    subject.name.should eq subject.to_s
  end

  it { should have_many :condominiums }

  it { should validate_presence_of :name }

end
