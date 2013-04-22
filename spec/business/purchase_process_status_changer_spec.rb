require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/purchase_process_status'
require 'app/business/purchase_process_status_changer'

describe PurchaseProcessStatusChanger do
  let(:purchase_process) { double(:purchase_process) }

  subject do
    described_class.new(purchase_process)
  end

  describe '#in_progress!' do
    context 'when not in progress' do
      before do
        purchase_process.stub(:in_progress? => false)
      end

      it "should update status to 'in_progress'" do
        purchase_process.should_receive(:update_status).with(PurchaseProcessStatus::IN_PROGRESS)

        subject.in_progress!
      end
    end

    context 'when in progress' do
      before do
        purchase_process.stub(:in_progress? => true)
      end

      it "should do nothing" do
        purchase_process.should_not_receive(:update_status).with(PurchaseProcessStatus::IN_PROGRESS)

        subject.in_progress!
      end
    end
  end
end
