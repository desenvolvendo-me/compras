require 'decorator_helper'
require 'app/decorators/administrative_process_budget_allocation_item_decorator'

describe AdministrativeProcessBudgetAllocationItemDecorator do
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
        component.stub(:total_price).and_return(9.99)
      end

      it 'should applies precision' do
        expect(subject.total_price).to eq 'R$ 9,99'
      end
    end
  end

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
        component.stub(:unit_price).and_return(9.99)
      end

      it 'should applies currency' do
        expect(subject.unit_price).to eq '9,99'
      end
    end
  end

  context '#unit_price_by_bidder' do
    context 'when unit_price_by_bider is nil' do
      before do
        component.stub(:unit_price_by_bidder).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.unit_price_by_bidder(nil)).to be_nil
      end
    end

    context 'when have unit_price_by_bidder' do
      before do
        component.stub(:unit_price_by_bidder).and_return 330.0
      end

      it 'should applies currency' do
        expect(subject.unit_price_by_bidder(nil)).to eq '330,00'
      end
    end
  end

  context '#total_value_by_bidder' do
    context 'when total_value_by_bidder is nil' do
      before do
        component.stub(:total_value_by_bidder).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.total_value_by_bidder(nil)).to be_nil
      end
    end

    context 'when total_value_by_bidder has value' do
      before do
        component.stub(:total_value_by_bidder).and_return(220.0)
      end

      it 'should applies precision' do
        expect(subject.total_value_by_bidder(nil)).to eq '220,00'
      end
    end
  end

  context '#quantity' do
    context 'when quantity is nil' do
      before do
        component.stub(:quantity).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.quantity).to be_nil
      end
    end

    context 'when quantity has value' do
      before do
        component.stub(:quantity).and_return(220.0)
      end

      it 'should applies precision' do
        expect(subject.quantity).to eq '220,00'
      end
    end
  end
end
