# encoding: utf-8
require 'spec_helper'

describe AdministrativeProcessBudgetAllocationItem do
  context '#unit_price_by_bidder' do
    subject do
      AdministrativeProcessBudgetAllocationItem.make!(:item)
    end

    it 'should return 0 as unit_price_by_bidder that does not have proposal' do
      bidder = Bidder.make!(:licitante_sobrinho)
      bidder.stub(:administrative_process_budget_allocation_item => subject)

      expect(subject.unit_price_by_bidder(bidder)).to eq 0
    end

    it 'should return proposal unit_price as unit_price_by_bidder have proposal' do
      bidder = Bidder.make!(:licitante_com_proposta_1)
      bidder.stub(:administrative_process_budget_allocation_item => subject)

      expect(subject.unit_price_by_bidder(bidder)).to eq 10
    end
  end
end