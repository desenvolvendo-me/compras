require 'unit_helper'
require 'app/business/delivery_location_changer'

describe DeliveryLocationChanger do
  let(:delivery_location) { double(:delivery_location, :id => 12) }

  context 'when object neither delivery_location nil' do
    let(:object) { double(:object) }

    subject do
      described_class.new(object, delivery_location)
    end

    describe '#change!' do
      context 'when delivery location is different' do
        let(:object_delivery_location) { double(:object_delivery_location) }

        before do
          object.stub(:delivery_location => object_delivery_location)
        end

        it 'should updates the the delivery location of object' do
          object.should_receive(:update_attributes).with(:delivery_location_id => 12)

          subject.change!
        end
      end
    end
  end

  context 'when object nil' do
    let(:object) { nil }

    subject do
      described_class.new(object, delivery_location)
    end

    describe '#change!' do
      it 'should do nothing' do
        object.should_not_receive(:update_attributes)

        subject.change!
      end
    end
  end

  context 'when delivery_location nil' do
    let(:object) { double(:object) }

    subject do
      described_class.new(object, nil)
    end

    before do
      object.stub(:delivery_location => delivery_location)
    end

    describe '#change!' do
      it 'should do nothing' do
        object.should_not_receive(:update_attributes)

        subject.change!
      end
    end
  end

  context 'when object does not respond_to delivery_location' do
    let(:object) { double(:object) }

    subject do
      described_class.new(object, delivery_location)
    end

    describe '#change!' do
      it 'should do nothing' do
        object.should_not_receive(:update_attributes)

        subject.change!
      end
    end
  end

  describe '.change' do
    let(:object) { double(:object) }
    let(:instance) { double(:instance) }

    it 'should instantiate and call change!' do
      described_class.should_receive(:new).
                      with(object, delivery_location).
                      and_return(instance)

      instance.should_receive(:change!)

      described_class.change(object, delivery_location)
    end
  end
end
