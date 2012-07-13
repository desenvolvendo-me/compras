require 'unit_helper'
require 'app/business/parcel_number_generator'

describe ParcelNumberGenerator do
  let :parcel_one do
    double
  end

  let :parcel_two do
    double
  end

  it 'should generate number to pledge_expeditions' do
    parcel_one.should_receive(:number=).with(1)
    parcel_two.should_receive(:number=).with(2)

    described_class.new([parcel_one, parcel_two]).generate!
  end
end
