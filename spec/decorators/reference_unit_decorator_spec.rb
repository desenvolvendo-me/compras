# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/reference_unit_decorator'

describe ReferenceUnitDecorator do
  context '#summary' do
    before do
      component.stub(:name => 'Meters')
    end

    it "should use name" do
      subject.summary.should eq 'Meters'
    end
  end
end
