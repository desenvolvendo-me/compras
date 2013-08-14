require 'spec_helper'

describe PurchaseProcessAccreditationsHelper do
  describe '#accreditation_path' do
    context 'when is persisted' do
      let(:resource) { double(:persisted? => true) }

      it 'should return accreditation_path' do
        helper.stub(:resource => resource)
        helper.stub(:purchase_process_accreditation_path => 'purchase_process_accreditation_path' )

        expect(helper.accreditation_path).to eq 'purchase_process_accreditation_path'
      end
    end

    context 'when is not persisted' do
      let(:resource) { double(:persisted? => false) }

      it 'should return #' do
        helper.stub(:resource => resource)

        expect(helper.accreditation_path).to eq '#'
      end
    end
  end
end
