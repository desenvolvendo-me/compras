require 'unit_helper'
require 'app/business/generate_number_pledge_expirations'

describe GenerateNumberPledgeExpirations do
  let :pledge_expedition_one do
    double
  end

  let :pledge_expedition_two do
    double
  end

  it "should generate number to pledge_expeditions" do
    pledge_expedition_one.should_receive(:number=).with(1)
    pledge_expedition_two.should_receive(:number=).with(2)

    described_class.new([pledge_expedition_one, pledge_expedition_two]).generate!
  end
end
