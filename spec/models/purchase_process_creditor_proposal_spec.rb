require 'model_helper'
require 'app/models/purchase_process_creditor_proposal'

describe PurchaseProcessCreditorProposal do
  it { should belong_to :creditor }
  it { should belong_to :licitation_process }
  it { should belong_to(:item).class_name('PurchaseProcessItem') }

  describe 'validations' do
    it { should validate_presence_of :creditor }
    it { should validate_presence_of :licitation_process }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of :lot }

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
  it { should delegate(:judgment_form).to(:licitation_process).allowing_nil(true).prefix(true) }

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
    let(:licitation_process) { double :licitation_process }
    let(:judgment_form)      { double :judgment_form, item?: true }

    before do
      subject.stub(:licitation_process).and_return licitation_process
      subject.stub(:licitation_process_judgment_form).and_return judgment_form
    end

    it 'returns true when licitation_process process judgment form is item' do
      expect(subject.item?).to be_true
    end
  end
end
