require 'model_helper'
require 'app/models/purchase_process_creditor_proposal'

describe PurchaseProcessCreditorProposal do
  it { should belong_to :creditor }
  it { should belong_to(:item).class_name('PurchaseProcessItem') }

  it { should have_one(:licitation_process).through(:item) }

  it { should validate_presence_of :creditor }
  it { should validate_presence_of :item }
  it { should validate_presence_of :brand }
  it { should validate_presence_of :unit_price }

  it { should delegate(:lot).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:additional_information).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:quantity).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:reference_unit).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:material).to(:item).allowing_nil(true).prefix(true) }

  describe '#total_price' do
    it 'multiplies the unit_price with the item quantity' do
      subject.stub(:item_quantity).and_return 3
      subject.unit_price = 1.99
      expect(subject.total_price).to eql 5.97
    end
  end
end
