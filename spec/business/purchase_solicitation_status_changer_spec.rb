require 'unit_helper'
require 'app/business/purchase_solicitation_status_changer'

describe PurchaseSolicitationStatusChanger do
  context 'change' do
    subject { described_class.new(purchase_solicitation) }

    let(:purchase_solicitation) { double(:purchase_solicitation, :items => [item_1, item_2]) }
    let(:item_1) { double(:item_1) }
    let(:item_2) { double(:item_2) }
    let(:attended_items) { double(:attended_items) }

    context 'when all items is attended' do
      before do
        purchase_solicitation.items.stub(:attended).and_return(attended_items)

        attended_items.stub(:any?).and_return(true)
        attended_items.stub(:count).and_return(2)
      end

      it 'purchase_solicitation should be attended' do
        purchase_solicitation.should_receive(:attend!)
        purchase_solicitation.should_not_receive(:partially_fulfilled!)

        subject.change!
      end
    end

    context 'when part of items is attended' do
      before do
        purchase_solicitation.items.stub(:attended).and_return(attended_items)

        attended_items.stub(:any?).and_return(true)
        attended_items.stub(:count).and_return(1)
      end

      it 'purchase_solicitation should be partially_fulfilled' do
        purchase_solicitation.should_not_receive(:attend!)
        purchase_solicitation.should_receive(:partially_fulfilled!)

        subject.change!
      end
    end

    context 'when any item is attended' do
      before do
        purchase_solicitation.items.stub(:attended).and_return(attended_items)

        attended_items.stub(:any?).and_return(false)
        attended_items.stub(:count).and_return(0)
      end

      it 'purchase_solicitation should be partially_fulfilled' do
        purchase_solicitation.should_not_receive(:attend!)
        purchase_solicitation.should_not_receive(:partially_fulfilled!)

        subject.change!
      end
    end
  end
end

