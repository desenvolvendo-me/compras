# encoding: utf-8
require 'spec_helper'

describe BidderProposal do
  it 'should return all proposals from a budget_allocation_item ordered by unit_price' do
    item = AdministrativeProcessBudgetAllocationItem.make!(:item_with_proposals)
    ordered_proposals = item.bidder_proposals.sort_by(&:unit_price)

    expect(BidderProposal.by_item_order_by_unit_price(item.id)).to eq ordered_proposals
    expect(BidderProposal.by_item_order_by_unit_price(item.id)).to_not eq item.bidder_proposals
  end
end