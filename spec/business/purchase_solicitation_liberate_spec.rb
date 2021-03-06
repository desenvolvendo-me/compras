require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/purchase_solicitation_liberate'

describe PurchaseSolicitationLiberate do
  describe '.liberate!' do
    subject { PurchaseSolicitationLiberate.new(purchase_solicitation) }

    context 'when has not a direct purchase' do
      let(:purchase_solicitation) do
        double(:purchase_solicitation, :direct_purchase => nil)
      end

      it 'should liberate purchase solicitation' do
        purchase_solicitation.should_receive(:liberate!)
        subject.liberate!
      end
    end
  end
end
