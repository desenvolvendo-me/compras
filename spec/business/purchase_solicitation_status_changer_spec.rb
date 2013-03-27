require 'unit_helper'
require 'app/business/purchase_solicitation_status_changer'

describe PurchaseSolicitationStatusChanger do
  context 'change' do
    before do
      purchase_solicitation_repository.should_receive(:find).with(purchase_solicitation).and_return(purchase_solicitation)
      purchase_solicitation.should_receive(:id).and_return(purchase_solicitation)
      purchase_solicitation.stub(:direct_purchase).and_return(direct_purchase)
      purchase_solicitation.stub(:licitation_process).and_return(licitation_process)
    end

    subject { described_class.new(purchase_solicitation, purchase_solicitation_repository) }

    let(:purchase_solicitation) { double(:purchase_solicitation, :id => 1, :items => [item_1, item_2]) }
    let(:purchase_solicitation_repository) { double(:purchase_solicitation_repository) }
    let(:item_1) { double(:item_1) }
    let(:item_2) { double(:item_2) }
    let(:direct_purchase) { double(:direct_purchase, :present? => false) }
    let(:licitation_process) { double(:licitation_process, :present? => false) }
    let(:relation) { double(:relation) }

    context 'when has a liberation' do
      before do
        purchase_solicitation.should_receive(:active_purchase_solicitation_liberation_liberated?).and_return(true)
      end

      it 'purchase_solicitation should be partially_fulfilled' do
        purchase_solicitation.should_receive(:attend!)
        purchase_solicitation.should_not_receive(:partially_fulfilled!)
        purchase_solicitation.should_not_receive(:pending!)
        purchase_solicitation.should_receive(:liberate!)

        subject.change!
      end
    end

    context 'when has not a liberation' do
      before do
        purchase_solicitation.should_receive(:active_purchase_solicitation_liberation_liberated?).and_return(false)
      end

      it 'purchase_solicitation should be partially_fulfilled' do
        purchase_solicitation.should_receive(:attend!)
        purchase_solicitation.should_not_receive(:partially_fulfilled!)
        purchase_solicitation.should_not_receive(:liberate!)
        purchase_solicitation.should_receive(:pending!)

        subject.change!
      end
    end
  end
end
