require 'spec_helper'

describe LicitationProcessesHelper do
  describe '#accreditation_path_helper' do
    let(:resource) { double(:resource, :id => 1) }
    let(:purchase_process_accreditation) { double(:purchase_process_accreditation, :id => 2, :to_param => '2') }

    before do
      helper.stub(:resource => resource)
    end

    context 'when resource is not persisted' do
      before do
        resource.stub(:persisted? => false)
      end

      it 'should return nil' do
        expect(helper.accreditation_path_helper).to be_nil
      end
    end

    context 'when resource is persisted' do
      before do
        resource.stub(:persisted? => true)
      end

      context 'when resource has a purchase_process_accreditation' do
        before do
          resource.stub(:purchase_process_accreditation => purchase_process_accreditation)
        end

        it  'should return the link to edit the purchase_process_accreditation' do
          expect(helper.accreditation_path_helper).to eq '/purchase_process_accreditations/2/edit?licitation_process_id=1'
        end
      end

      context 'when resource have not a purchase_process_accreditation' do
        before do
          resource.stub(:purchase_process_accreditation => nil)
        end

        it  'should return the link to a new purchase_process_accreditation' do
          expect(helper.accreditation_path_helper).to eq '/purchase_process_accreditations/new?licitation_process_id=1'
        end
      end
    end
  end

  describe '#trading_path_helper' do
    let(:resource) { double(:resource, id: 10) }
    let(:trading) { double(:trading) }

    before do
      helper.stub(resource: resource)
    end

    context 'when has a trading' do
      before do
        resource.stub(has_trading?: true)
        resource.stub(trading: trading)
      end

      it 'should return the link to bids' do
        helper.should_receive(:bids_purchase_process_trading_path).with(trading).and_return('bids_path')

        expect(helper.trading_path_helper).to eq 'bids_path'
      end
    end

    context 'when have not a trading' do
      before do
        resource.stub(has_trading?: false)
      end

      it 'should return the link to new' do
        helper.should_receive(:new_purchase_process_trading_path).
               with(purchase_process_id: 10).
               and_return('new_path')

        expect(helper.trading_path_helper).to eq 'new_path'
      end
    end
  end
end
