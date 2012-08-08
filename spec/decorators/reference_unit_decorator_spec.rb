# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/reference_unit_decorator'

describe ReferenceUnitDecorator do
  context '#summary' do
    before do
      component.stub(:name).and_return('Meters')
    end

    it "should use name" do
      expect(subject.summary).to eq 'Meters'
    end
  end
end
