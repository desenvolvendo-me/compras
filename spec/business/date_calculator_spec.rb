require 'unit_helper'
require 'active_support/time'
require 'app/business/date_calculator'

describe DateCalculator do
  let(:initial_date) { Date.new(2013, 6, 1) }
  let(:holiday) { double(:holiday) }

  describe '#calculate' do
    context 'when context is :calendar and initial date 01/06/2013 and 5 days' do
      subject do
        described_class.new(initial_date, 5, :calendar, holiday)
      end

      it { expect(subject.calculate).to eq Date.new(2013, 6, 6) }
    end

    context 'when context is :working' do
      subject do
        described_class.new(initial_date, 5, :working, holiday)
      end

      it do
        holiday.should_receive(:is_a_holiday?).exactly(5).times.and_return(false)
        expect(subject.calculate).to eq Date.new(2013, 6, 7)
      end
    end
  end

  describe '.calculate' do
    it 'should instantiate and call #calculate' do
      instance = double(:instance)
      described_class.should_receive(:new).with(initial_date, 3, :calendar, holiday).and_return instance
      instance.should_receive(:calculate)

      described_class.calculate(initial_date, 3, :calendar, holiday)
    end
  end
end
