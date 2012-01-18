require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/status_of_transfer'
require 'app/business/transfer_property'

describe TransferProperty do
  let(:lower_payment_object) { double 'LowerPayment' }
  let(:property) { double 'Property' }
  let(:property_transfer) { double 'PropertyTransfer' }

  subject { described_class.new(lower_payment_object) }

  it "should transfer the owner" do
    lower_payment_object.should_receive(:fact_generatable).exactly(4).times.and_return(property)
    property.should_receive(:property_transfers).exactly(3).times.and_return(property_transfer)
    property_transfer.should_receive(:where).exactly(3).times.with(:status => StatusOfTransfer::OPEN).and_return(property_transfer)
    property_transfer.should_receive(:any?).and_return(true)
    property_transfer.should_receive(:first).exactly(2).times.and_return(property_transfer)

    property_transfer.should_receive(:buyer_id).and_return(1)
    property.should_receive(:update_attributes!).with(:owner_id => 1).and_return(true)
    property_transfer.should_receive(:update_attributes!).with(:status => StatusOfTransfer::TRANSFERED).and_return(true)

    subject.transfer!
  end
end
