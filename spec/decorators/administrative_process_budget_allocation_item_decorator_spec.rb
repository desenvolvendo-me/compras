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

  context '#winner_proposals_unit_price' do
    context 'when do not have winner_proposals_unit_price' do
      before do
        component.stub(:winner_proposals_unit_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.winner_proposals_unit_price).to eq nil
      end
    end

    context 'when have winner_proposals_unit_price' do
      before do
        component.stub(:winner_proposals_unit_price).and_return(9.99)
      end

      it 'should applies precision' do
        expect(subject.winner_proposals_unit_price).to eq '9,99'
      end
    end
  end

  context '#winner_proposals_total_price' do
    context 'when do not have winner_proposals_total_price' do
      before do
        component.stub(:winner_proposals_total_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.winner_proposals_total_price).to eq nil
      end
    end

    context 'when have winner_proposals_total_price' do
      before do
        component.stub(:winner_proposals_total_price).and_return(9.99)
      end

      it 'should applies precision' do
        expect(subject.winner_proposals_total_price).to eq '9,99'
      end
    end
  end
end
