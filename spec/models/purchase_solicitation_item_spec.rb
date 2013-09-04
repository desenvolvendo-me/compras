require 'model_helper'
require 'app/models/budget_structure'
require 'app/models/expense_nature'
require 'app/models/purchase_solicitation_item'
require 'app/models/purchase_solicitation'
require 'app/models/price_collection'
require 'app/models/price_collection_item'
require 'app/models/price_collection_proposal_item'
require 'app/models/material'

describe PurchaseSolicitationItem do
  it { should belong_to :purchase_solicitation }
  it { should belong_to :material }

  it { should have_many(:price_collection_proposal_items).through(:purchase_solicitation) }

  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }

  it "should validate material_characteristic if purchase of services" do
    material = double(:material, :service? => false)
    subject.stub(:services? => true)
    subject.stub(:material => material)

    subject.valid?

    expect(subject.errors[:material]).to include "deve ter a característica de Serviço"
  end

  it { should delegate(:services?).to(:purchase_solicitation).allowing_nil(true) }
  it { should delegate(:budget_structure).to(:purchase_solicitation).allowing_nil(true).prefix(true) }
  it { should delegate(:material_characteristic).to(:material).allowing_nil(true) }

  it 'should calculate total price' do
    expect(subject.estimated_total_price).to eq 0

    subject.quantity = 10
    subject.unit_price = 5

    expect(subject.estimated_total_price).to eq 50
  end

  describe '#estimated_total_price_rounded' do
    it 'should return the estimated total price rounded' do
      subject.stub(:estimated_total_price => 8.1892)

      expect(subject.estimated_total_price_rounded).to eq 8.19
    end
  end

  describe '#average_proposal_item_price' do
    let(:price_collection_proposal_items) { double :price_collection_proposal_items }

    it 'returns the average proposal item price' do
      subject.price_collection_proposal_items.should_receive(:average).with :unit_price
      subject.average_proposal_item_price
    end
  end

  describe '#average_proposal_total_price' do
    before do
      subject.stub(:quantity).and_return 3
      subject.stub(:average_proposal_item_price).and_return 11.90
    end

    it 'returns the average proposal item price times the quantity' do
      expect(subject.average_proposal_total_price.to_f).to eql 35.70
    end
  end

  describe '#proposal_total_price_winner' do
    before do
      subject.stub(:quantity).and_return 3
      subject.stub(:proposal_unit_price_winner).and_return 10.90
    end

    it 'returns the unit price of the winner proposal times the quantity' do
      expect(subject.proposal_total_price_winner).to eql 32.70
    end
  end

  describe '#proposal_unit_price_winner' do
    let(:price_collection_proposal_winner) do
      double(:price_collection_proposal_winner, unit_price: 10.00)
    end

    context 'when theres a winner proposal' do
      before do
        subject.stub(:price_collection_proposal_winner).and_return price_collection_proposal_winner
      end

      it 'returns the unit price of the winner proposal' do
        expect(subject.proposal_unit_price_winner).to eql 10.00
      end
    end

    context 'when theres no winning proposal' do
      before do
        subject.stub(:price_collection_proposal_winner).and_return nil
      end

      it 'returns nil' do
        expect(subject.proposal_unit_price_winner).to be_nil
      end
    end
  end

  describe '#proposal_creditor_winner' do
    let(:price_collection_proposal_winner) do
      double(:price_collection_proposal_winner, creditor: "Creditor")
    end

    context 'when theres a winner proposal' do
      before do
        subject.stub(:price_collection_proposal_winner).and_return price_collection_proposal_winner
      end

      it 'returns the the winner proposal creditor' do
        expect(subject.proposal_creditor_winner).to eql 'Creditor'
      end
    end

    context 'when theres no winning proposal' do
      before do
        subject.stub(:price_collection_proposal_winner).and_return nil
      end

      it 'returns nil' do
        expect(subject.proposal_creditor_winner).to be_nil
      end
    end
  end
end
