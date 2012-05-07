# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_decorator'

describe LicitationProcessDecorator do
  it 'should return localized envelope_delivery_time' do
    component.stub(:envelope_delivery_time).and_return(Time.new(2012, 1, 4, 10))
    helpers.stub(:l).with(Time.new(2012, 1, 4, 10), :format => :hour).and_return('10:00')

    subject.envelope_delivery_time.should eq '10:00'
  end

  it 'should return localized opening_delivery_time' do
    component.stub(:envelope_opening_time).and_return(Time.new(2012, 2, 4, 11))
    helpers.stub(:l).with(Time.new(2012, 2, 4, 11), :format => :hour).and_return('11:00')

    subject.envelope_opening_time.should eq '11:00'
  end

  it 'should return a link to count when envelope_opening? is true' do
    component.stub(:envelope_opening? => true)
    helpers.stub(:link_to).with('Apurar', '#', :class => "button primary").and_return('link')

    subject.count_link.should eq 'link'
  end

  it 'should not return a link to count when envelope_opening? is false' do
    component.stub(:envelope_opening? => false)

    subject.count_link.should eq nil
  end
end
