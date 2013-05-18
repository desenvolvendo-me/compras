require 'model_helper'
require 'app/models/purchase_process_creditor_proposal'
require 'app/models/licitation_process'
require 'app/business/purchase_process_creditor_proposal_ranking'

describe PurchaseProcessCreditorProposal do
  it { should belong_to :creditor }
  it { should belong_to :licitation_process }
  it { should belong_to(:item).class_name('PurchaseProcessItem') }

  it { should have_one(:judgment_form).through(:licitation_process) }

  describe 'validations' do
    it { should validate_presence_of :creditor }
    it { should validate_presence_of :licitation_process }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of :lot }
    it { should validate_numericality_of :ranking }

    describe 'brand' do
      context 'when licitaton process judgment form is item' do
        before { subject.stub(:item?).and_return true }
        it { should validate_presence_of :brand }
      end

      context 'when licitaton process judgment form is not item' do
        before { subject.stub(:item?).and_return false }
        it { should_not validate_presence_of :brand }
      end
    end
  end

  it { should delegate(:lot).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:additional_information).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:quantity).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:reference_unit).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:material).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:creditor).allowing_nil(true).prefix(true) }
  it { should delegate(:cnpj).to(:creditor).allowing_nil(true).prefix(true) }
  it { should delegate(:benefited).to(:creditor).allowing_nil(true).prefix(true) }

  describe '#total_price' do
    it 'multiplies the unit_price with the item quantity' do
      subject.stub(:item_quantity).and_return 3
      subject.unit_price = 1.99
      expect(subject.total_price).to eql 5.97
    end
  end

  describe '#disqualify!' do
    it 'updates the disqualified attribute to true' do
      subject.should_receive(:update_attribute).with(:disqualified, true)
      subject.disqualify!
    end
  end

  describe '#qualify!' do
    it 'updates the disqualified attribute to false' do
      subject.should_receive(:update_attribute).with(:disqualified, false)
      subject.qualify!
    end
  end

  describe '#item?' do
    let(:judgment_form) { double :judgment_form, item?: true }

    it 'returns true when licitation_process process judgment form is item' do
      subject.stub(:judgment_form).and_return judgment_form
      expect(subject.item?).to be_true
    end
  end

  describe '#update_ranking' do
    it 'updates the ranking of proposals' do
      PurchaseProcessCreditorProposalRanking.should_receive(:rank!).with subject

      subject.send(:update_ranking)
    end
  end

  describe '#qualified?' do
    it 'returns true if the object is not disqualified' do
      subject.disqualified = false
      expect(subject.qualified?).to be_true
    end
  end

  describe '#reset_ranking!' do
    it 'updates the ranking column to 0' do
      subject.should_receive(:update_column).with(:ranking, 0)
      subject.reset_ranking!
    end
  end
end
