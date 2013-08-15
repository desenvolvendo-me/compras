require 'decorator_helper'
require 'app/decorators/licitation_process_ratification_item_decorator'

describe LicitationProcessRatificationItemDecorator do
  context '#unit_price' do
    context 'when do not have unit_price' do
      before do
        component.stub(:unit_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.unit_price).to be_nil
      end
    end

    context 'when have unit_price' do
      before do
        component.stub(:unit_price).and_return(5000.0)
      end

      it 'should applies precision' do
        expect(subject.unit_price).to eq '5.000,00'
      end
    end
  end

  context '#total_price' do
    context 'when do not have total_price' do
      before do
        component.stub(:total_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.total_price).to be_nil
      end
    end

    context 'when have total_price' do
      before do
        component.stub(:total_price).and_return(5000.0)
      end

      it 'should applies precision' do
        expect(subject.total_price).to eq '5.000,00'
      end
    end
  end

  describe '#creditor_proposal_id_or_mustache_variable' do
    context 'when component has a purchase_process_creditor_proposal_id' do
      before do
        component.stub(:purchase_process_creditor_proposal_id => 10)
      end

      it 'should return the purchase_process_creditor_proposal_id' do
        expect(subject.creditor_proposal_id_or_mustache_variable).to eq 10
      end
    end

    context "when component's purchase_process_creditor_proposal_id is nil" do
      before do
        component.stub(:purchase_process_creditor_proposal_id => nil)
      end

      it 'should return the {{purchase_process_creditor_proposal_id}}' do
        expect(subject.creditor_proposal_id_or_mustache_variable).to eq '{{purchase_process_creditor_proposal_id}}'
      end
    end
  end

  describe '#realignment_price_item_id_or_mustache_variable' do
    context 'when component has a realignment_price_item_id' do
      before do
        component.stub(:realignment_price_item_id => 10)
      end

      it 'should return the purchase_process_creditor_proposal_id' do
        expect(subject.realignment_price_item_id_or_mustache_variable).to eq 10
      end
    end

    context "when component's realignment_price_item_id is nil" do
      before do
        component.stub(:realignment_price_item_id => nil)
      end

      it 'should return the {{realignment_price_item_id}}' do
        expect(subject.realignment_price_item_id_or_mustache_variable).to eq '{{realignment_price_item_id}}'
      end
    end
  end

  describe '#code_or_mustache_variable' do
    context 'when component has a code' do
      before do
        component.stub(:code => 10)
      end

      it 'should return the code' do
        expect(subject.code_or_mustache_variable).to eq 10
      end
    end

    context "when component's code is nil" do
      before do
        component.stub(:code => nil)
      end

      it 'should return the {{code}}' do
        expect(subject.code_or_mustache_variable).to eq '{{code}}'
      end
    end
  end

  describe '#description_or_mustache_variable' do
    context 'when component has a description' do
      before do
        component.stub(:description => 'Antivirus')
      end

      it 'should return the description' do
        expect(subject.description_or_mustache_variable).to eq 'Antivirus'
      end
    end

    context "when component's description is nil" do
      before do
        component.stub(:description => nil)
      end

      it 'should return the {{description}}' do
        expect(subject.description_or_mustache_variable).to eq '{{description}}'
      end
    end
  end

  describe '#reference_unit_or_mustache_variable' do
    context 'when component has a reference_unit' do
      before do
        component.stub(:reference_unit => 10)
      end

      it 'should return the reference_unit' do
        expect(subject.reference_unit_or_mustache_variable).to eq 10
      end
    end

    context "when component's reference_unit is nil" do
      before do
        component.stub(:reference_unit => nil)
      end

      it 'should return the {{reference_unit}}' do
        expect(subject.reference_unit_or_mustache_variable).to eq '{{reference_unit}}'
      end
    end
  end

  describe '#quantity_or_mustache_variable' do
    context 'when component has a quantity' do
      before do
        component.stub(:quantity => 10)
      end

      it 'should return the quantity' do
        expect(subject.quantity_or_mustache_variable).to eq 10
      end
    end

    context "when component's quantity is nil" do
      before do
        component.stub(:quantity => nil)
      end

      it 'should return the {{quantity}}' do
        expect(subject.quantity_or_mustache_variable).to eq '{{quantity}}'
      end
    end
  end

  describe '#total_price_or_mustache_variable' do
    context 'when component has a total_price' do
      before do
        component.stub(:total_price => 10)
      end

      it 'should return the total_price' do
        expect(subject.total_price_or_mustache_variable).to eq '10,00'
      end
    end

    context "when component's total_price is nil" do
      before do
        component.stub(:total_price => nil)
      end

      it 'should return the {{total_price}}' do
        expect(subject.total_price_or_mustache_variable).to eq '{{total_price}}'
      end
    end
  end

  describe '#unit_price_or_mustache_variable' do
    context 'when component has a unit_price' do
      before do
        component.stub(:unit_price => 10)
      end

      it 'should return the unit_price' do
        expect(subject.unit_price_or_mustache_variable).to eq '10,00'
      end
    end

    context "when component's unit_price is nil" do
      before do
        component.stub(:unit_price => nil)
      end

      it 'should return the {{unit_price}}' do
        expect(subject.unit_price_or_mustache_variable).to eq '{{unit_price}}'
      end
    end
  end

  describe '#purchase_process_item_id_or_mustache_variable' do
    context 'when has not a purchase_process_item_id' do
      before do
        component.stub(purchase_process_item_id: nil)
      end

      it 'should return the mustache variable' do
        expect(subject.purchase_process_item_id_or_mustache_variable).to eq '{{purchase_process_item_id}}'
      end
    end

    context 'when has a purchase_process_item_id' do
      before do
        component.stub(purchase_process_item_id: 10)
      end

      it 'should return the purchase_process_item_id' do
        expect(subject.purchase_process_item_id_or_mustache_variable).to eq 10
      end
    end
  end

  describe '#trading_item_id_or_mustache_variable' do
    context 'when has not a trading_item_id' do
      before do
        component.stub(purchase_process_trading_item_id: nil)
      end

      it 'should return the mustache variable' do
        expect(subject.trading_item_id_or_mustache_variable).to eq '{{purchase_process_trading_item_id}}'
      end
    end

    context 'when has a trading_item_id' do
      before do
        component.stub(purchase_process_trading_item_id: 10)
      end

      it 'should return the trading_item_id' do
        expect(subject.trading_item_id_or_mustache_variable).to eq 10
      end
    end
  end

  describe '#authorized_value' do
    context 'theres authorized_value ' do
      before { component.stub(authorized_value: 10.15) }

      it 'returns formatted authorized_value' do
        expect(subject.authorized_value).to eq '10,15'
      end
    end

    context 'theres not authorized_value ' do
      before { component.stub(authorized_value: nil) }

      it 'returns nil' do
        expect(subject.authorized_value).to be_nil
      end
    end
  end

  describe '#supply_order_item_value_balance' do
    context 'theres supply_order_item_value_balance' do
      before { component.stub(supply_order_item_value_balance: 10.15) }

      it 'returns formatted supply_order_item_value_balance' do
        expect(subject.supply_order_item_value_balance).to eq '10,15'
      end
    end

    context 'theres not supply_order_item_value_balance' do
      before { component.stub(supply_order_item_value_balance: nil) }

      it 'returns nil' do
        expect(subject.supply_order_item_value_balance).to be_nil
      end
    end
  end
end
