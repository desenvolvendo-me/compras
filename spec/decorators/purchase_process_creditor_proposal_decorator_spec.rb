require 'decorator_helper'
require 'app/decorators/purchase_process_creditor_proposal_decorator'

describe PurchaseProcessCreditorProposalDecorator do
  describe '#unit_price' do
    it 'returns the formatted item unit price' do
      component.stub(:unit_price).and_return 1000.12
      expect(subject.unit_price).to eql "1.000,12"
    end
  end

  describe '#total_price' do
    it 'returns the formatted total price' do
      component.stub(:total_price).and_return 11000.12
      expect(subject.total_price).to eql "11.000,12"
    end
  end

  describe "#unit_price_with_currency" do
    it 'return with currency unit_price' do
      component.stub(:unit_price).and_return 1050.30
      expect(subject.unit_price_with_currency).to eql "R$ 1.050,30"
    end
  end

  describe "#total_price_with_currency" do
    it 'return with currency total_price' do
      component.stub(:total_price).and_return 10500.30
      expect(subject.total_price_with_currency).to eql "R$ 10.500,30"
    end
  end

  describe '#css_class' do
    let :proposal do
      double('PurchaseProcessCreditorProposal', :id => 1)
    end

    let(:map_of_proposal) { double(:map_of_proposal) }

    it 'return draw when draw' do
      map_of_proposal.stub(:draw?).and_return true
      map_of_proposal.stub(:lowest_proposal?).and_return false

      expect(subject.css_class(map_of_proposal)).to eql "draw"
    end
  end
end
