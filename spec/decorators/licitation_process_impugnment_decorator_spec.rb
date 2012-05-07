# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_impugnment_decorator'

describe LicitationProcessImpugnmentDecorator do
  it 'should return localized licitation_process_envelope_delivery_date' do
    component.stub(:licitation_process_envelope_delivery_date).and_return(Date.new(2012, 1, 4))
    helpers.stub(:l).with(Date.new(2012, 1, 4)).and_return('01/04/2012')

    subject.licitation_process_envelope_delivery_date.should eq '01/04/2012'
  end

  it 'should return localized licitation_process_envelope_delivery_time' do
    component.stub(:licitation_process_envelope_delivery_time).and_return(Time.new(2012, 1, 4, 10))
    helpers.stub(:l).with(Time.new(2012, 1, 4, 10), :format => :hour).and_return('10:00')

    subject.licitation_process_envelope_delivery_time.should eq '10:00'
  end

  it 'should return localized licitation_process_envelope_opening_date' do
    component.stub(:licitation_process_envelope_opening_date).and_return(Date.new(2012, 2, 4))
    helpers.stub(:l).with(Date.new(2012, 2, 4)).and_return('02/04/2012')

    subject.licitation_process_envelope_opening_date.should eq '02/04/2012'
  end

  it 'should return localized licitation_process_envelope_opening_time' do
    component.stub(:licitation_process_envelope_opening_time).and_return(Time.new(2012, 2, 4, 11))
    helpers.stub(:l).with(Time.new(2012, 2, 4, 11), :format => :hour).and_return('11:00')

    subject.licitation_process_envelope_opening_time.should eq '11:00'
  end
end
