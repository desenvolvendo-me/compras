# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/licitation_process_impugnment_presenter'

describe LicitationProcessImpugnmentPresenter do
  subject do
    described_class.new(licitation_process_impugnment, nil, helpers)
  end

  let :licitation_process_impugnment do
    double(:licitation_process_envelope_delivery_date => Date.new(2012, 1, 4),
           :licitation_process_envelope_delivery_time => Time.new(2012, 1, 4, 10),
           :licitation_process_envelope_opening_date => Date.new(2012, 2, 4),
           :licitation_process_envelope_opening_time => Time.new(2012, 2, 4, 11))
  end

  let :helpers do
    double 'helpers'
  end

  it 'should return localized licitation_process_envelope_delivery_date' do
    helpers.stub(:l).with(Date.new(2012, 1, 4)).and_return('01/04/2012')

    subject.licitation_process_envelope_delivery_date.should eq '01/04/2012'
  end

  it 'should return localized licitation_process_envelope_delivery_time' do
    helpers.stub(:l).with(Time.new(2012, 1, 4, 10), :format => :hour).and_return('10:00')

    subject.licitation_process_envelope_delivery_time.should eq '10:00'
  end

  it 'should return localized licitation_process_envelope_opening_date' do
    helpers.stub(:l).with(Date.new(2012, 2, 4)).and_return('02/04/2012')

    subject.licitation_process_envelope_opening_date.should eq '02/04/2012'
  end

  it 'should return localized licitation_process_envelope_opening_time' do
    helpers.stub(:l).with(Time.new(2012, 2, 4, 11), :format => :hour).and_return('11:00')

    subject.licitation_process_envelope_opening_time.should eq '11:00'
  end
end
