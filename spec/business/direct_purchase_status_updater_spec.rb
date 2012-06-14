require 'unit_helper'
require 'app/business/direct_purchase_status_updater'

describe DirectPurchaseStatusUpdater do
  let :liberation do
    double('Purchase Liberation', :direct_purchase => purchase, :evaluation => 'xpto')
  end

  let :purchase do
    double('Purchase')
  end

  subject do
    described_class.new(liberation)
  end

  describe '#update!' do
    it 'updates the purchase status with the evaluation on the liberation' do
      purchase.should_receive(:update_status!).with('xpto')

      subject.update!
    end
  end
end
