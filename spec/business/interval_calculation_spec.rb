require 'unit_helper'
require 'active_support/time'
require 'enumerate_it'
require 'app/business/interval_calculation'

describe IntervalCalculation do
  describe '#prolongate' do
    it 'should prolongate date by days' do
      expect(IntervalCalculation.new(Date.new(2011, 10, 20), :interval_type => 'day', :interval_number => 10).prolongate).to eq Date.new(2011, 10, 30)
    end

    it 'should prolongate date by months' do
      expect(IntervalCalculation.new(Date.new(2011, 10, 20), :interval_type => 'month', :interval_number => 3).prolongate).to eq Date.new(2012, 1, 20)
    end

    it 'should prolongate date by years' do
      expect(IntervalCalculation.new(Date.new(2011, 10, 20), :interval_type => 'year', :interval_number => 2).prolongate).to eq Date.new(2013, 10, 20)
    end
  end
end
