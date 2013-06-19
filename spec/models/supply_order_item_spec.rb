# encoding: utf-8
require 'model_helper'
require 'app/models/supply_order_item'
require 'app/models/licitation_process_ratification_item'

describe SupplyOrderItem do
  it { should belong_to :supply_order }
  it { should belong_to :licitation_process_ratification_item }

  it { should delegate(:material).to(:licitation_process_ratification_item).allowing_nil(true) }
  it { should delegate(:reference_unit).to(:licitation_process_ratification_item).allowing_nil(true) }
  it { should delegate(:unit_price).to(:licitation_process_ratification_item).allowing_nil(true) }
  it { should delegate(:total_price).to(:licitation_process_ratification_item).allowing_nil(true) }
  it { should delegate(:supply_order_item_balance).to(:licitation_process_ratification_item).allowing_nil(true) }
  it { should delegate(:supply_order_item_value_balance).to(:licitation_process_ratification_item).allowing_nil(true) }
  it { should delegate(:control_amount?).to(:material).allowing_nil true }

  context 'validations' do
    before do
      subject.stub(supply_order_item_value_balance: 0)
    end

    describe '#authorization_value' do
      it 'should be greater than 0' do
        subject.authorization_value = 0

        expect(subject.valid?).to be_false
        expect(subject.errors[:authorization_value]).to include("deve ser maior que 0")
      end
    end

    describe '#authorization_quantity' do
      it 'should be greater than 0' do
        subject.authorization_quantity = 0

        expect(subject.valid?).to be_false
        expect(subject.errors[:authorization_quantity]).to include("deve ser maior que 0")
      end
    end
  end

  describe "#balance" do
    it "when quantity is greater than authorized balance is greater than zero" do
      subject.stub(:quantity).and_return(3)
      subject.stub(:authorized_quantity).and_return(1)

      expect(subject.balance).to eq 2
    end
  end

  describe "#quantity" do
    let(:licitation_process_ratification_item) { double :licitation_process_ratification_item }

    it 'tries to return licitation_process_ratification_item quantity' do
      subject.stub(licitation_process_ratification_item: licitation_process_ratification_item)
      licitation_process_ratification_item.should_receive(:try).with :quantity

      subject.quantity
    end
  end

  describe '#value' do
    let(:licitation_process_ratification_item) { double :licitation_process_ratification_item }

    it 'tries to return licitation_process_ratification_item value' do
      subject.stub(licitation_process_ratification_item: licitation_process_ratification_item)
      licitation_process_ratification_item.should_receive(:try).with :unit_price

      subject.value
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
end
