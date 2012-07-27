# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_decorator'

describe LicitationProcessDecorator do
  let :time do
    Time.new(2012, 1, 4, 10)
  end

  context '#envelope_delivery_time' do
    context 'when do not have envelope_delivery_time' do
      before do
        component.stub(:envelope_delivery_time).and_return(nil)
      end

      it 'should be nil' do
        subject.envelope_delivery_time.should be_nil
      end
    end

    context 'when have envelope_delivery_time' do
      before do
        component.stub(:envelope_delivery_time).and_return(time)
      end

      it 'should localize envelope_delivery_time' do
        subject.envelope_delivery_time.should eq '10:00'
      end
    end
  end

  context '#envelope_opening_time' do
    context 'when do not have envelope_opening_time' do
      before do
        component.stub(:envelope_opening_time).and_return(nil)
      end

      it 'should be nil' do
        subject.envelope_opening_time.should be_nil
      end
    end

    context 'when have envelope_opening_time' do
      before do
        component.stub(:envelope_opening_time).and_return(time)
      end

      it 'should return localized opening_delivery_time' do
        subject.envelope_opening_time.should eq '10:00'
      end
    end
  end

  context '#parent_url' do
    context 'when have parent' do
      before do
        routes.stub(:edit_administrative_process_path).with(parent).and_return('link')
      end

      let :parent do
        double('AdministrativeProcess', :id => 1)
      end

      it 'should return a url to administrative process when has parent' do
        subject.parent_url(parent).should eq 'link'
      end
    end

    context 'when do not have parent' do
      before do
        routes.stub(:licitation_processes_path).and_return('link')
      end

      it 'should return a url to licitation processes when has not parent' do
        subject.parent_url(nil).should eq 'link'
      end
    end
  end

  context '#winner_proposal_total_price' do
    context 'when do not have winner_proposal_total_price' do
      before do
        component.stub(:winner_proposal_total_price).and_return(nil)
      end

      it 'should be nil' do
        subject.winner_proposal_total_price.should be_nil
      end
    end

    context 'when have winner_proposal_total_price' do
      before do
        component.stub(:winner_proposal_total_price).and_return(9.99)
      end

      it 'should applies currency' do
        subject.winner_proposal_total_price.should eq 'R$ 9,99'
      end
    end
  end
end
