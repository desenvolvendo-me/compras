require 'model_helper'
require 'app/models/realignment_price_item'

describe RealignmentPriceItem do
  it { should validate_presence_of :price }

  it { should belong_to(:item) }
  it { should belong_to(:realignment_price) }

  it { should have_one(:creditor).through :realignment_price }
  it { should have_one(:material).through :item }
  it { should have_one(:purchase_process).through :realignment_price }

  it { should have_many(:creditor_proposals).through :purchase_process }

  describe 'delegates' do
    it { should delegate(:judgment_form_lot?).to(:purchase_process).allowing_nil(true) }
    it { should delegate(:year).to(:purchase_process).allowing_nil(true).prefix(true) }
    it { should delegate(:process).to(:purchase_process).allowing_nil(true).prefix(true) }
    it { should delegate(:identity_document).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:reference_unit).to(:material).allowing_nil(true).prefix(true) }
    it { should delegate(:code).to(:material).allowing_nil(true).prefix(true) }
    it { should delegate(:description).to(:material).allowing_nil(true).prefix(true) }
    it { should delegate(:lot).to(:item).allowing_nil(true) }
  end

  describe '#quantity' do
    let(:item) { double(:item, quantity: 100) }

    context 'when item is nil' do
      it 'should return zero' do
        expect(subject.quantity).to eq 0
      end
    end

    context 'when item is not nil' do
      before do
        subject.stub(item: item)
      end

      it "should return the item's quantity" do
        expect(subject.quantity).to eq 100
      end
    end
  end

  describe '#total_price' do
    before do
      subject.stub(quantity: 3)
      subject.price = 2.99
    end

    it 'returns the sum of item quantity and price' do
      expect(subject.total_price.to_f).to eq 8.97
    end
  end
end
