require 'unit_helper'
require 'app/business/number_year_parser'

describe NumberYearParser do
  it "should return the number" do
    NumberYearParser.new("001/2012").number.should eq "001"
  end

  it "should return the year" do
    NumberYearParser.new("001/2012").year.should eq "2012"
  end
end
