require 'unit_helper'
require 'app/business/itbi_calculator'

describe ItbiCalculator do
  let(:property_transfer_object) { double("PropertyTransfer") }
  let(:property) { double("Property") }
  let(:setting_repository) { double("Setting") }

  subject { described_class.new(property_transfer_object, setting_repository) }

  it "should calculate the tax without amount financed" do
    property_transfer_object.should_receive(:property).and_return(property)
    property.should_receive(:market_value).and_return(10000.0)
    property.should_receive(:terrain_market_value).and_return(0)
    property_transfer_object.should_receive(:declared_value_of_transaction).twice.and_return(100000.0)
    property_transfer_object.should_receive(:amount_financed).twice.and_return(0)
    setting_repository.should_receive(:fetch).with(:rate_property_transfer).and_return("2")
    setting_repository.should_receive(:fetch).with(:rate_property_transfer_funded).and_return("0.5")

    subject.call.should eql 2000.0
  end

  it "should calculate the tax without amount financed" do
    property_transfer_object.should_receive(:property).and_return(property)
    property.should_receive(:market_value).and_return(10000.0)
    property.should_receive(:terrain_market_value).and_return(0)
    property_transfer_object.should_receive(:declared_value_of_transaction).twice.and_return(100000.0)
    property_transfer_object.should_receive(:amount_financed).twice.and_return(80000.0)
    setting_repository.should_receive(:fetch).with(:rate_property_transfer).and_return("2")
    setting_repository.should_receive(:fetch).with(:rate_property_transfer_funded).and_return("0.5")

    subject.call.should eql 800.0
  end
end
