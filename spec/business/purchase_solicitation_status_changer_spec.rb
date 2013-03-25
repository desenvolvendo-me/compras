require 'unit_helper'
require 'app/business/purchase_solicitation_status_changer'

describe PurchaseSolicitationStatusChanger do
  context 'change' do
    before do
      purchase_solicitation_repository.should_receive(:find).with(purchase_solicitation).and_return(purchase_solicitation)
      purchase_solicitation.should_receive(:id).and_return(purchase_solicitation)
      purchase_solicitation.stub(:direct_purchase).and_return(direct_purchase)
      purchase_solicitation.stub(:licitation_process).and_return(licitation_process)
      purchase_solicitation.items.stub(:attended).and_return(attended_items)
      purchase_solicitation.items.stub(:pending).and_return(pending_items)
    end

    subject { described_class.new(purchase_solicitation, purchase_solicitation_repository) }

    let(:purchase_solicitation) { double(:purchase_solicitation, :id => 1, :items => [item_1, item_2]) }
    let(:purchase_solicitation_repository) { double(:purchase_solicitation_repository) }
    let(:item_1) { double(:item_1) }
    let(:item_2) { double(:item_2) }
    let(:attended_items) { double(:attended_items) }
    let(:pending_items) { double(:pending_items) }
    let(:direct_purchase) { double(:direct_purchase, :present? => false) }
    let(:licitation_process) { double(:licitation_process, :present? => false) }
    let(:relation) { double(:relation) }

    context 'when all items is attended' do
      before do
        attended_items.stub(:any?).and_return(true)
        pending_items.stub(:any?).and_return(false)
        attended_items.stub(:count).and_return(2)
      end

      it 'purchase_solicitation should be attended' do
        purchase_solicitation.should_receive(:attend!)
        purchase_solicitation.should_not_receive(:partially_fulfilled!)
        purchase_solicitation.should_not_receive(:liberate!)
        purchase_solicitation.should_not_receive(:pending!)

        subject.change!
      end
    end

    context 'when part of items is attended' do
      before do

        attended_items.stub(:any?).and_return(true)
        pending_items.stub(:any?).and_return(false)
        attended_items.stub(:count).and_return(1)
      end

      it 'purchase_solicitation should be partially_fulfilled' do
        purchase_solicitation.should_not_receive(:attend!)
        purchase_solicitation.should_not_receive(:liberate!)
        purchase_solicitation.should_not_receive(:pending!)
        purchase_solicitation.should_receive(:partially_fulfilled!)

        subject.change!
      end
    end

    context 'when any item is attended' do
      before do
        attended_items.stub(:any?).and_return(false)
        pending_items.stub(:any?).and_return(false)
        attended_items.stub(:count).and_return(0)
        purchase_solicitation.items.should_receive(:partially_fulfilled).and_return(relation)
        relation.should_receive(:any?).and_return(false)
      end

      it 'purchase_solicitation should not be partially_fulfilled and attend' do
        purchase_solicitation.should_not_receive(:attend!)
        purchase_solicitation.should_not_receive(:partially_fulfilled!)
        purchase_solicitation.should_not_receive(:liberate!)
        purchase_solicitation.should_not_receive(:pending!)

        subject.change!
      end
    end

    context 'when has a liberation' do
      before do
        attended_items.stub(:any?).and_return(false)
        pending_items.stub(:any?).and_return(true)
        attended_items.stub(:count).and_return(0)
        pending_items.stub(:count).and_return(2)
        purchase_solicitation.should_receive(:active_purchase_solicitation_liberation_liberated?).and_return(true)
        purchase_solicitation.items.should_receive(:partially_fulfilled).and_return(relation)
        relation.should_receive(:any?).and_return(false)
      end

      it 'purchase_solicitation should be partially_fulfilled' do
        purchase_solicitation.should_not_receive(:attend!)
        purchase_solicitation.should_not_receive(:partially_fulfilled!)
        purchase_solicitation.should_not_receive(:pending!)
        purchase_solicitation.should_receive(:liberate!)

        subject.change!
      end
    end

    context 'when has not a liberation' do
      before do
        attended_items.stub(:any?).and_return(false)
        pending_items.stub(:any?).and_return(true)
        attended_items.stub(:count).and_return(0)
        pending_items.stub(:count).and_return(2)
        purchase_solicitation.should_receive(:active_purchase_solicitation_liberation_liberated?).and_return(false)
        purchase_solicitation.items.should_receive(:partially_fulfilled).and_return(relation)
        relation.should_receive(:any?).and_return(false)
      end

      it 'purchase_solicitation should be partially_fulfilled' do
        purchase_solicitation.should_not_receive(:attend!)
        purchase_solicitation.should_not_receive(:partially_fulfilled!)
        purchase_solicitation.should_not_receive(:liberate!)
        purchase_solicitation.should_receive(:pending!)

        subject.change!
      end
    end
  end
end
