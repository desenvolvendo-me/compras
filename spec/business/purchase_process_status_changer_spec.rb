require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/purchase_process_status'
require 'app/business/purchase_process_status_changer'

describe PurchaseProcessStatusChanger do
  let(:bidders) { double(:bidders) }
  let(:purchase_process) { double(:purchase_process, bidders: bidders) }

  subject do
    described_class.new(purchase_process)
  end

  describe '#in_progress!' do
    context 'when not in progress' do
      before do
        purchase_process.stub(:in_progress? => false)
      end

      context 'when has no bidders_enabled' do
        before do
          bidders.stub(enabled: [])
        end

        it "should not update status to 'in_progress'" do
          purchase_process.should_not_receive(:update_status)

          subject.in_progress!
        end
      end

      context 'when has bidders_enabled' do
        before do
          bidders.stub(enabled: ['bidders'])
        end

        it "should update status to 'in_progress'" do
          purchase_process.should_receive(:update_status).with(PurchaseProcessStatus::IN_PROGRESS)

          subject.in_progress!
        end
      end
    end

    context 'when in progress' do
      before do
        purchase_process.stub(:in_progress? => true)
      end

      it "should do nothing" do
        purchase_process.should_not_receive(:update_status)

        subject.in_progress!
      end
    end
  end
end
