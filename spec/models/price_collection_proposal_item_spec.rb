require 'model_helper'
require 'app/models/price_collection_proposal_item'

describe PriceCollectionProposalItem do
  it { should belong_to :price_collection_proposal }
  it { should belong_to :price_collection_item }

  it { should have_one(:price_collection).through(:price_collection_proposal) }

  it { should delegate(:material).to(:price_collection_item).allowing_nil true }
  it { should delegate(:brand).to(:price_collection_item).allowing_nil true }
  it { should delegate(:reference_unit).to(:price_collection_item).allowing_nil true }
  it { should delegate(:quantity).to(:price_collection_item).allowing_nil true }
  it { should delegate(:lot).to(:price_collection_item).allowing_nil true }
  it { should delegate(:creditor).to(:price_collection_proposal).allowing_nil true }
  it { should delegate(:editable_by?).to(:price_collection_proposal).allowing_nil true }
  it { should delegate(:price_collection).to(:price_collection_proposal).allowing_nil true }

  it 'should return 0 as the total price default value' do
    expect(subject.total_price).to eq 0
  end

  it 'should return 0 as the unit price default value' do
    expect(subject.unit_price).to eq 0.0
  end

  describe '#total_price' do
    it 'when both values is filled' do
      subject.unit_price = 5
      subject.stub(:quantity).and_return(5)

      expect(subject.total_price).to eq 25
    end

    it 'when has unit_price only' do
      subject.unit_price = 5

      expect(subject.total_price).to eq 0.00
    end

    it 'when has quantity only' do
      subject.stub(:quantity).and_return(5)

      expect(subject.total_price).to eq 0.00
    end
  end

  it 'should return the total price with quantity and unit_price' do
    subject.stub(:quantity).and_return(5)
    subject.stub(:unit_price).and_return(10)

    expect(subject.total_price).to eq 50
  end
end
