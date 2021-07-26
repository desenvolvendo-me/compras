require 'model_helper'
require 'app/models/purchase_process_accreditation_creditor'
require 'app/models/purchase_process_trading_item_bid'

describe PurchaseProcessAccreditationCreditor do
  it { should belong_to(:purchase_process_accreditation) }
  it { should belong_to(:creditor) }
  it { should belong_to(:company_size) }
  it { should belong_to(:creditor_representative) }

  it { should have_many(:trading_item_bids).class_name('PurchaseProcessTradingItemBid').dependent(:restrict) }

  describe 'delegations' do
    it { should delegate(:personable_type_humanize).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:address).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:city).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:state).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:identity_document).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:neighborhood).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:zip_code).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:phone).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:person_email).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:company?).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:individual?).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:proposal_by_lot).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:identity_document).to(:creditor_representative).allowing_nil(true).prefix(true) }
    it { should delegate(:phone).to(:creditor_representative).allowing_nil(true).prefix(true) }
    it { should delegate(:email).to(:creditor_representative).allowing_nil(true).prefix(true) }
    it { should delegate(:identity_number).to(:creditor_representative).allowing_nil(true).prefix(true) }
    it { should delegate(:benefited?).to(:company_size).allowing_nil(true) }
  end

  describe "validations" do
    it { should validate_presence_of :creditor }
    it { should validate_presence_of :purchase_process_accreditation }
    it { should_not validate_presence_of :kind}
    it { should_not validate_presence_of :company_size }

    context 'when is a company' do
      before do
        subject.stub(:creditor_company?).and_return(true)
      end

      it { should validate_presence_of :company_size }
    end

    context 'with creditor_representative' do
      let(:creditor_representative) { double(:creditor_representative) }

      before do
        creditor_representative.stub(:present? => true)
        subject.stub(:creditor_representative => creditor_representative)
      end

      it { should validate_presence_of :kind }
    end
  end

  describe 'to_s' do
    it 'should return the to_s of creditor' do
      subject.stub(creditor: double(:creditor, to_s: 'creditor 1'))

      expect(subject.to_s).to eq 'creditor 1'
    end
  end
end
