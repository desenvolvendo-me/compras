# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/licitation_process_presenter'

describe LicitationProcessPresenter do
  subject do
    described_class.new(licitation_process, nil, helpers)
  end

  let :licitation_process do
    double(:envelope_delivery_time => Time.new(2012, 1, 4, 10),
           :envelope_opening_time => Time.new(2012, 2, 4, 11))
  end

  let :helpers do
    double 'helpers'
  end

  it 'should return localized envelope_delivery_time' do
    helpers.stub(:l).with(Time.new(2012, 1, 4, 10), :format => :hour).and_return('10:00')

    subject.envelope_delivery_time.should eq '10:00'
  end

  it 'should return localized opening_delivery_time' do
    helpers.stub(:l).with(Time.new(2012, 2, 4, 11), :format => :hour).and_return('11:00')

    subject.envelope_opening_time.should eq '11:00'
  end

  it 'should return a link to count when envelope_opening? is true' do
    helpers.stub(:link_to).with('Apurar', '#', :class => "button primary").and_return('link')
    licitation_process.stub(:envelope_opening? => true)

    subject.count_link.should eq 'link'
  end

  it 'should not return a link to count when envelope_opening? is false' do
    licitation_process.stub(:envelope_opening? => false)

    subject.count_link.should eq nil
  end
end
