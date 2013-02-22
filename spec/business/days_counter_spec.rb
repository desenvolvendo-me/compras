require 'unit_helper'
require 'app/business/days_counter'

describe DaysCounter do
  subject do
    initial_date = Date.new 2013, 02, 18
    end_date     = Date.new 2013, 02, 27
    described_class.new(initial_date, end_date, holiday_repository)
  end

  let(:holiday_repository) { double :holiday_repository }

  describe "#count" do
    context "calendar days" do
      it "counts the quantity of calendar days between the initial and end date" do
        expect(subject.count).to eq 10
      end

      it "counts holidays and weekends as calendar days" do
        holiday_repository.stub(:is_a_holiday?).and_return true, true, false
        expect(subject.count).to eq 10
      end
    end

    context "working days" do
      it "excludes saturday and sunday from the counting" do
        holiday_repository.stub(:is_a_holiday?).and_return false
        expect(subject.count(:working)).to eq 8
      end

      it "excludes holidays from the counting" do
        holiday_repository.stub(:is_a_holiday?).and_return true, false
        expect(subject.count(:working)).to eq 7
      end
    end
  end
end
