require 'decorator_helper'
require 'app/decorators/administrative_process_budget_allocation_item_decorator'

describe AdministrativeProcessBudgetAllocationItemDecorator do
  context '#total_price' do
    context 'when do not have total_price' do
      before do
        component.stub(:total_price).and_return(nil)
      end

      it 'should be nil' do
        subject.total_price.should be_nil
      end
    end

    context 'when have total_price' do
      before do
        component.stub(:total_price).and_return(9.99)
      end

      it 'should applies precision' do
        subject.total_price.should eq 'R$ 9,99'
      end
    end
  end

  context '#unit_price' do
    context 'when do not have unit_price' do
      before do
        component.stub(:unit_price).and_return(nil)
      end

      it 'should be nil' do
        subject.unit_price.should be_nil
      end
    end

    context 'when have unit_price' do
      before do
        component.stub(:unit_price).and_return(9.99)
      end

      it 'should applies currency' do
        subject.unit_price.should eq '9,99'
      end
    end
  end

  context '#winner_proposals_unit_price' do
    context 'when do not have winner_proposals_unit_price' do
      before do
        component.stub(:winner_proposals_unit_price).and_return(nil)
      end

      it 'should be nil' do
        subject.winner_proposals_unit_price.should eq nil
      end
    end

    context 'when have winner_proposals_unit_price' do
      before do
        component.stub(:winner_proposals_unit_price).and_return(9.99)
      end

      it 'should applies precision' do
        subject.winner_proposals_unit_price.should eq '9,99'
      end
    end
  end

  context '#winner_proposals_total_price' do
    context 'when do not have winner_proposals_total_price' do
      before do
        component.stub(:winner_proposals_total_price).and_return(nil)
      end

      it 'should be nil' do
        subject.winner_proposals_total_price.should eq nil
      end
    end

    context 'when have winner_proposals_total_price' do
      before do
        component.stub(:winner_proposals_total_price).and_return(9.99)
      end

      it 'should applies precision' do
        subject.winner_proposals_total_price.should eq '9,99'
      end
    end
  end
end
