require 'unit_helper'
require 'lib/percent_calculator'

describe PercentCalculator do
  it "should get a value with discount" do
    percent_calculator = PercentCalculator.new(:initial_value => 100.0, :percent => 20.0)

    expect(percent_calculator.subtract_percentage).to eq 80.0
  end

  it "should get the percent descrease" do
    percent_calculator = PercentCalculator.new(:initial_value => 200.0, :final_value => 50.0)

    expect(percent_calculator.percent_decrease).to eq 75.0
  end

  it "should get the percent increase" do
    percent_calculator = PercentCalculator.new(:initial_value => 200.0, :final_value => 400.0)

    expect(percent_calculator.percent_increase).to eq 100.0
  end

  it "should not calculate when the initial value is less than 0" do
    percent_calculator = PercentCalculator.new(:initial_value => -100.0, :percent => 20.0)

    expect { percent_calculator.subtract_percentage }.to raise_error ArgumentError
  end

  it "should get the percent increase only when the final_value is equal or greater then the initial_value" do
    percent_calculator = PercentCalculator.new(:initial_value => 200.0, :final_value => 50.0)

    expect { percent_calculator.percent_increase }.to raise_error ArgumentError
  end

  it "should get the percent decrease only when the initial_value is equal or greater then the final_value" do
    percent_calculator = PercentCalculator.new(:initial_value => 200.0, :final_value => 400.0)

    expect { percent_calculator.percent_decrease }.to raise_error ArgumentError
  end

  it "the percent decrease and increase should be 0 when the final value and initial value are equal" do
    percent_calculator = PercentCalculator.new(:initial_value => 100.0, :final_value => 100.0)

    expect(percent_calculator.percent_increase).to eq 0.0
    expect(percent_calculator.percent_decrease).to eq 0.0
  end

  it "by default the initial values and percent should be 0.0" do
    percent_calculator = PercentCalculator.new

    expect(percent_calculator.initial_value).to eq 0.0
    expect(percent_calculator.final_value).to eq   0.0
    expect(percent_calculator.percent).to eq       0.0
  end
end
