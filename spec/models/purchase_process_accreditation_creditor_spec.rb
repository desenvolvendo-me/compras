# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_process_accreditation_creditor'

describe PurchaseProcessAccreditationCreditor do
  it { should belong_to(:purchase_process_accreditation) }
  it { should belong_to(:creditor) }
  it { should belong_to(:company_size) }
  it { should belong_to(:creditor_representative) }

  describe "validations" do
    it { should validate_presence_of :creditor }
    it { should validate_presence_of :company_size }
    it { should validate_presence_of :purchase_process_accreditation }
    it { should_not validate_presence_of :kind}

    context 'with creditor_representative' do
      let(:creditor_representative) { double(:creditor_representative) }

      before do
        creditor_representative.stub(:present? => true)
        subject.stub(:creditor_representative => creditor_representative)
      end

      it { should validate_presence_of :kind}
    end
  end
end
