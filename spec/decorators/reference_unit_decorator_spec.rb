# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/reference_unit_decorator'

describe ReferenceUnitDecorator do
  it "should return name as summary" do
    component.stub(:name => 'Meters')
    subject.summary.should eq 'Meters'
  end
end

