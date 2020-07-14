require 'model_helper'
require 'app/models/purchase_process_creditor_proposal'
require 'app/models/licitation_process'
require 'app/models/purchase_process_item'
require 'app/business/purchase_process_creditor_proposal_ranking'

describe PurchaseProcessCreditorProposal do
  it { should belong_to :creditor }
  it { should belong_to :licitation_process }
  it { should belong_to(:item).class_name('PurchaseProcessItem') }

  it { should have_many(:bidders).through(:licitation_process) }

  it { should have_one(:judgment_form).through(:licitation_process) }
  it { should have_one(:licitation_process_ratifications).through(:licitation_process) }
  it { should have_one(:material).through(:item) }

  describe 'validations' do
    it { should validate_presence_of :creditor }
    it { should validate_presence_of :licitation_process }
    it { should validate_numericality_of :lot }
    it { should validate_numericality_of :ranking }

    describe 'brand' do
      context 'when licitaton process judgment form is item and price is greater than 0' do
        before do
          subject.stub(item?: true)
          subject.stub(unit_price: 10)
        end

        it { should validate_presence_of :brand }
      end

      context 'when licitaton process judgment form is not item' do
        before { subject.stub(:item?).and_return false }
        it { should_not validate_presence_of :brand }
      end
    end

    describe 'unit_price' do
      context 'brand is not nil' do
        before { subject.brand = 'Marca' }

        it 'validates unit price is greater than 0' do
          subject.stub(item?: true)

          expect(subject.valid?).to be_false
          expect(subject.errors[:unit_price]).to include('deve ser maior que 0')
        end
      end

      context 'brand is nil' do
        before { subject.brand = nil }

        it 'does not validate unit price is greater than 0' do
          subject.stub(item?: true)
          subject.valid?

          expect(subject.errors[:unit_price]).to be_empty
        end
      end
    end
  end

  it { should delegate(:code).to(:material).allowing_nil(true).prefix(true) }
  it { should delegate(:description).to(:material).allowing_nil(true).prefix(true) }
  it { should delegate(:reference_unit).to(:material).allowing_nil(true).prefix(true) }

  it { should delegate(:lot).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:additional_information).to(:item).allowing_nil(true).prefix(true) }
  it { should delegate(:quantity).to(:item).allowing_nil(true).prefix(true) }

  it { should delegate(:name).to(:creditor).allowing_nil(true).prefix(true) }
  it { should delegate(:cnpj).to(:creditor).allowing_nil(true).prefix(true) }
  it { should delegate(:benefited).to(:creditor).allowing_nil(true).prefix(true) }
  it { should delegate(:identity_document).to(:creditor).allowing_nil(true).prefix(true) }

  it { should delegate(:year).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }

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

      subject.run_callbacks(:save)
    end
  end

  describe '#item_or_lot_or_purchase_process' do
    context 'when there is item' do
      before { subject.stub(:item).and_return 'item' }

      it 'returns item' do
        expect(subject.item_or_lot_or_purchase_process).to eql 'item'
      end
    end

    context 'when there is no item and there is lot' do
      before do
        subject.stub(:item).and_return nil
        subject.stub(:lot).and_return 'lot'
      end

      it 'returns lot' do
        expect(subject.item_or_lot_or_purchase_process).to eql 'lot'
      end
    end

    context 'when there is no item and no lot' do
      before do
        subject.stub(:item).and_return nil
        subject.stub(:lot).and_return nil
        subject.stub(:licitation_process).and_return 'licitation_process'
      end

      it 'returns licitation process' do
        expect(subject.item_or_lot_or_purchase_process).to eql 'licitation_process'
      end
    end
  end

  describe '#available_rankings' do
    let(:cheaper_brothers)    { double(:cheaper_brothers, size: 2) }
    let(:same_price_brothers) { double(:same_price_brothers, size: 2) }

    before do
      subject.stub(:cheaper_brothers).and_return cheaper_brothers
      subject.stub(:same_price_brothers).and_return same_price_brothers
    end

    it 'returns an array of available rankings for the proposal' do
      expect(subject.available_rankings).to eql [3, 4]
    end
  end

  describe '#qualified?' do
    it 'returns true if the object is not disqualified' do
      subject.disqualified = false
      expect(subject.qualified?).to be_true
    end
  end

  describe '#tie_ranking!' do
    it 'updates the ranking column to 0 and tie the proposal' do
      subject.should_receive(:update_column).with :ranking, 0
      subject.should_receive(:update_column).with :tied, true
      subject.tie_ranking!
    end
  end

  describe '#reset_ranking!' do
    it 'updates the ranking column to -1 and untie the proposal' do
      subject.should_receive(:apply_ranking!).with -1
      subject.reset_ranking!
    end
  end

  describe '#apply_ranking!' do
    it 'updates the ranking column and set tied to false' do
      subject.should_receive(:update_column).with :ranking, 1
      subject.should_receive(:update_column).with :tied, false
      subject.apply_ranking! 1
    end
  end

  describe '#reset_old_unit_price' do
    before do
      subject.stub(:should_reset_old_unit_price?).and_return true
    end

    it 'sets the old_unit_price to nil when updating' do
      subject.should_receive(:write_attribute).with(:old_unit_price, nil)
      subject.run_callbacks(:update)
    end
  end

  describe 'should_reset_old_unit_price?' do
    context "there is no update of old_unit_price and there is a update of unit_price" do
      before do
        subject.stub(:old_unit_price_changed?).and_return false
        subject.stub(:unit_price_changed?).and_return true
      end

      it 'returns true' do
        expect(subject.send(:should_reset_old_unit_price?)).to be_true
      end
    end
  end

  describe '#should_validate_brand_presence?' do
    it 'returns true if judgment form is item' do
      subject.stub(item?: true)
      subject.stub(unit_price: 10)

      expect(subject.send(:should_validate_brand_presence?)).to be_true
    end

    it 'returns true if unit price is greater than 0' do
      subject.stub(item?: true)
      subject.stub(unit_price: nil)
      expect(subject.send(:should_validate_brand_presence?)).to be_false

      subject.stub(unit_price: 10)
      expect(subject.send(:should_validate_brand_presence?)).to be_true
    end
  end

  describe '#benefited_tied?' do
    before { subject.stub(:creditor).and_return creditor }

    context 'theres no tie nor the creditor is benefited' do
      let(:creditor) { double :creditor, benefited: false }

      before { subject.tied = false }

      it 'returns false' do
        expect(subject.benefited_tied?).to be_false
      end
    end

    context 'theres a tied, the creditor is benefited but his proposal was to high' do
      let(:creditor) { double :creditor, benefited: false }

      before do
        subject.tied = true
        subject.unit_price = 2.00
        subject.stub(:benefited_unit_price).and_return 1.00
      end

      it 'returns false' do
        expect(subject.benefited_tied?).to be_false
      end
    end

    context 'theres is a tie, the creditor is benefited and is using the benefit' do
      let(:creditor) { double :creditor, benefited: true }

      before do
        subject.tied = true
        subject.unit_price = 1.10
        subject.stub(:benefited_unit_price).and_return 1.00
      end

      it 'returns true' do
        expect(subject.benefited_tied?).to be_true
      end
    end
  end
end
