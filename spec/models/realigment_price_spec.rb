require 'model_helper'
require 'app/models/realigment_price'
require 'app/models/purchase_process_creditor_proposal'

describe RealigmentPrice do
  it { should validate_presence_of :price }

  it { should belong_to(:item).class_name('PurchaseProcessItem') }
  it { should belong_to(:proposal).class_name('PurchaseProcessCreditorProposal') }

  it { should have_one(:licitation_process).through :proposal }
  it { should have_one(:creditor).through :proposal }
  it { should have_one(:material).through :item }

  it { should delegate(:execution_unit_responsible).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:year).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }

  it { should delegate(:name).to(:creditor).allowing_nil(true).prefix(true) }
  it { should delegate(:cnpj).to(:creditor).allowing_nil(true).prefix(true) }
  it { should delegate(:benefited).to(:creditor).allowing_nil(true).prefix(true) }
  it { should delegate(:identity_document).to(:creditor).allowing_nil(true).prefix(true) }

  it { should delegate(:code).to(:material).allowing_nil(true).prefix(true) }
  it { should delegate(:description).to(:material).allowing_nil(true).prefix(true) }
  it { should delegate(:reference_unit).to(:material).allowing_nil(true).prefix(true) }

  it { should delegate(:lot).to(:proposal).allowing_nil(true).prefix(false) }

  describe '#total_price' do
    let(:item) { double(:item, quantity: 3) }

    before do
      subject.stub(:item).and_return item
      subject.price = 2.99
    end

    it 'returns the sum of item quantity and price' do
      expect(subject.total_price.to_f).to eq 8.97
    end
  end
end
