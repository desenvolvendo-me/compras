require 'model_helper'
require 'app/models/pledge_item'
require 'app/models/supply_order_item'

describe SupplyOrderItem do
  it { should belong_to :supply_order }
  it { should belong_to :material }

  it { should delegate(:unit_price).to(:pledge_item).allowing_nil(true) }
  it { should delegate(:estimated_total_price).to(:pledge_item).allowing_nil(true).prefix(true) }
  it { should delegate(:service_without_quantity?).to(:material).allowing_nil true }
  it { should delegate(:reference_unit).to(:material).allowing_nil(true) }

  describe '#value' do
    let(:pledge_item) { double :pledge_item }

    it 'tries to return pledge_item value' do
      subject.stub(pledge_item: pledge_item)
      pledge_item.should_receive(:unit_price).and_return(44.4)

      expect(subject.value).to eq 44.4
    end
  end

  describe '#value_balance' do
    before do
      subject.stub(:value).and_return 10
      subject.stub(:authorized_value).and_return 3
    end

    it 'returns the value - authorized value' do
      expect(subject.value_balance).to eq 7
    end
  end

  it "#authorization_quantity_should_be_lower_than_quantity" do
    subject.stub(:real_authorization_quantity).and_return(4)
    subject.stub(:supply_order_item_balance).and_return(3)

    subject.valid?
    expect(subject.errors[:authorization_quantity]).to include("deve ser menor ou igual a 3")
  end

  describe '#authorization_value_should_be_lower_than_value' do
    before do
      subject.stub(real_authorization_value: 10)
      subject.stub(supply_order_item_value_balance: 5)
      subject.stub(authorization_value_changed?: true)
      subject.stub(authorization_value_limit: '4,00')
    end

    it 'sets an error if authorization_value is greater than value' do
      subject.valid?

      expect(subject.errors[:authorization_value]).to include("deve ser menor ou igual a 4,00")
    end
  end

  describe '#total_price' do
    context 'when pledge_item_estimated_total_price is nil' do
      before do
        subject.stub(pledge_item_estimated_total_price: nil)
      end

      it 'should return 0' do
        expect(subject.total_price).to eq 0
      end
    end

    context 'when pledge_item_estimated_total_price is not nil' do
      before do
        subject.stub(pledge_item_estimated_total_price: 50)
      end

      it 'should return the pledge_item_estimated_total_price' do
        expect(subject.total_price).to eq 50
      end
    end
  end
end
