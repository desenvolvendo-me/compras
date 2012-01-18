require 'unit_helper'
require 'lib/business_day'

describe BusinessDay do
  subject do
    BusinessDay.new(saturday)
  end

  let :friday do
    Date.new(2011, 10, 28)
  end

  let :saturday do
    Date.new(2011, 10, 29)
  end

  let :monday do
    Date.new(2011, 10, 31)
  end

  it "should calculate the previous working day" do
    subject.previous_business_day.should eq friday
  end

  it "should calculate the next working day" do
    subject.next_business_day.should eq monday
  end
end
