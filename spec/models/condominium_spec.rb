# encoding: utf-8
require 'model_helper'
require 'config/initializers/inflections'
require 'app/models/condominium'
require 'app/models/address'

describe Condominium do
  it "return name when converted to String" do
    subject.name = "Tambuatá"
    subject.name.should eq subject.to_s
  end

  it { should belong_to :condominium_type }
  it { should have_one :address }

  it { should validate_presence_of :name }
  it { should validate_presence_of :built_area }
  it { should validate_presence_of :area_common_user }
  it { should validate_presence_of :construction_year }
  it { should validate_presence_of :condominium_type }
  it { should validate_numericality_of :construction_year }

end
