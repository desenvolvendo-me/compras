require 'decorator_helper'
require 'app/decorators/supply_order_item_decorator'

describe SupplyOrderItemDecorator do
  describe '#nested_form_path' do
    context 'when item has service_without_quantity' do
      before { component.stub(service_without_quantity?: true) }

      it 'renders values form template' do
        expect(subject.nested_form_path).to eq 'supply_order_items/form_value'
      end
    end

    context 'when item doesnt have service_without_quantity' do
      before { component.stub(service_without_quantity?: false) }

      it 'render quantity form template' do
        expect(subject.nested_form_path).to eq 'supply_order_items/form_quantity'
      end
    end
  end

  describe '#unit_price' do
    context 'theres unit_price' do
      before { component.stub(unit_price: 10.15) }

      it 'returns formatted unit_price' do
        expect(subject.unit_price).to eq '10,15'
      end
    end

    context 'theres not unit_price' do
      before { component.stub(unit_price: nil) }

      it 'returns nil' do
        expect(subject.unit_price).to be_nil
      end
    end
  end

  describe '#total_price' do
    context 'theres total_price' do
      before { component.stub(total_price: 10.15) }

      it 'returns formatted total_price' do
        expect(subject.total_price).to eq '10,15'
      end
    end

    context 'theres not total_price' do
      before { component.stub(total_price: nil) }

      it 'returns nil' do
        expect(subject.total_price).to be_nil
      end
    end
  end

  describe '#authorized_value' do
    context 'theres authorized_value' do
      before { component.stub(authorized_value: 10.15) }

      it 'returns formatted authorized_value' do
        expect(subject.authorized_value).to eq '10,15'
      end
    end

    context 'theres not authorized_value' do
      before { component.stub(authorized_value: nil) }

      it 'returns nil' do
        expect(subject.authorized_value).to be_nil
      end
    end
  end

  describe '#value_balance' do
    context 'theres value_balance' do
      before { component.stub(value_balance: 10.15) }

      it 'returns formatted value_balance' do
        expect(subject.value_balance).to eq '10,15'
      end
    end

    context 'theres not value_balance' do
      before { component.stub(value_balance: nil) }

      it 'returns nil' do
        expect(subject.value_balance).to be_nil
      end
    end
  end
end
