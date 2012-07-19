# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_impugnment_decorator'

describe LicitationProcessImpugnmentDecorator do
  let :date do
    Date.new(2012, 1, 4)
  end

  let :time do
    Time.new(2012, 1, 3, 10)
  end

  context '#licitation_process_envelope_delivery_date' do
    before do
      component.stub(:licitation_process_envelope_delivery_date).and_return(date)
      helpers.stub(:l).with(date).and_return('01/04/2012')
    end

    it 'should return localized licitation_process_envelope_delivery_date' do
      subject.licitation_process_envelope_delivery_date.should eq '01/04/2012'
    end
  end

  context '#licitation_process_envelope_delivery_time' do
    before do
      component.stub(:licitation_process_envelope_delivery_time).and_return(time)
      helpers.stub(:l).with(time, :format => :hour).and_return('10:00')
    end

    it 'should return localized licitation_process_envelope_delivery_time' do
      subject.licitation_process_envelope_delivery_time.should eq '10:00'
    end
  end

  context '#licitation_process_envelope_opening_date' do
    before do
      component.stub(:licitation_process_envelope_opening_date).and_return(date)
      helpers.stub(:l).with(date).and_return('01/04/2012')
    end

    it 'should return localized licitation_process_envelope_opening_date' do
      subject.licitation_process_envelope_opening_date.should eq '01/04/2012'
    end
  end

  context '#licitation_process_envelope_opening_time' do
    before do
      component.stub(:licitation_process_envelope_opening_time).and_return(time)
      helpers.stub(:l).with(time, :format => :hour).and_return('10:00')
    end

    it 'should return localized licitation_process_envelope_opening_time' do
      subject.licitation_process_envelope_opening_time.should eq '10:00'
    end
  end
end
