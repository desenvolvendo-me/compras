require 'spec_helper'

describe PledgeRequestsHelper do
  describe '#reserve_funds' do
    context 'when has no purchase_process' do
      it 'should return an empty array' do
        expect(helper.reserve_funds(nil)).to be_empty
      end
    end

    context 'when has a purchase_process' do
      let(:purchase_process) { double(:purchase_process )}

      context 'when has no reserve_funds_available' do
        it 'should return an empty array' do
          purchase_process.should_receive(:reserve_funds_available).and_return([])

          expect(helper.reserve_funds(purchase_process)).to be_empty
        end
      end

      context 'when has reserve_funds_available' do
        let(:reserve_fund) { double(:reserve_fund, id: 10, to_s: '10/2013', amount: 1050.98) }

        it 'should return the data for options' do
          purchase_process.should_receive(:reserve_funds_available).and_return([reserve_fund])

          expect(helper.reserve_funds(purchase_process)).to eq [[10, '10/2013', { 'data-amount' => '1.050,98' }]]
        end
      end
    end
  end
end
