# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_decorator'

describe LicitationProcessDecorator do
  let :time do
    Time.new(2012, 1, 4, 10)
  end

  context '#envelope_delivery_time' do
    before do
      component.stub(:envelope_delivery_time).and_return(time)
      helpers.stub(:l).with(time, :format => :hour).and_return('10:00')
    end

    it 'should localize envelope_delivery_time' do
      subject.envelope_delivery_time.should eq '10:00'
    end
  end

  context '#envelope_opening_time' do
    before do
      component.stub(:envelope_opening_time).and_return(time)
      helpers.stub(:l).with(time, :format => :hour).and_return('10:00')
    end

    it 'should return localized opening_delivery_time' do
      subject.envelope_opening_time.should eq '10:00'
    end
  end

  context '#count_link' do
    before do
      component.stub(:persisted?).and_return(true)
      routes.stub(:licitation_process_path).and_return('#')
      helpers.stub(:link_to).with('Apurar', '#', :class => "button primary").and_return('link')
    end

    it 'should return a link to count when envelope_opening? is true' do
      component.stub(:envelope_opening? => true)

      subject.count_link.should eq 'link'
    end

    it 'should not return a link to count when envelope_opening? is false' do
      component.stub(:envelope_opening? => false)

      subject.count_link.should eq nil
    end
  end

  context '#winner_proposal_total_price' do
    before do
      component.stub(:winner_proposal_total_price).and_return(9.99)
      helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')
    end

    it 'should applies currency' do
      subject.winner_proposal_total_price.should eq 'R$ 9,99'
    end
  end
end
