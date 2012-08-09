# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_bidder_proposal_decorator'

describe LicitationProcessBidderProposalDecorator do
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
end
