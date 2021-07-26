require 'model_helper'
require 'app/models/purchase_process_item'
require 'app/models/licitation_process_classification'
require 'app/models/bidder_proposal'
require 'app/models/purchase_process_creditor_proposal'
require 'app/models/purchase_process_trading_item_bid'
require 'app/models/licitation_process_ratification_item'

describe PurchaseProcessItem do
  it { should validate_presence_of :material }
  it { should validate_presence_of :quantity }
  it { should validate_presence_of :lot }

  it { should belong_to :material }
  it { should belong_to :licitation_process }
  it { should belong_to :creditor }

  it { should have_many :bidder_proposals }
  it { should have_many(:creditor_proposals).dependent(:destroy) }
  it { should have_many(:licitation_process_classifications).dependent(:destroy) }
  it { should have_many(:purchase_process_accreditation_creditors) }

  it { should have_one(:purchase_process_accreditation) }
  it { should have_one(:ratification_item).dependent(:restrict) }
  it { should have_one(:material_class) }

  it { should delegate(:reference_unit).to(:material).allowing_nil(true) }
  it { should delegate(:description).to(:material).allowing_nil(true) }
  it { should delegate(:direct_purchase?).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:judgment_form_item?).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:unit_price).to(:ratification_item).allowing_nil(true).prefix(true) }
  it { should delegate(:total_price).to(:ratification_item).allowing_nil(true).prefix(true) }

  it { should auto_increment(:item_number).by([:licitation_process_id, :lot]) }

  describe "creditor validation" do
    it 'does not validate presence when not direct purchase' do
      subject.stub(:direct_purchase?).and_return false
      subject.valid?
      expect(subject.errors[:creditor]).to be_empty
    end
  end

  context 'with material' do
    let :material do
      double(:material)
    end

    it 'should return material.to_s as to_s' do
      subject.stub(:material).and_return(material)

      material.stub(:to_s).and_return('Cadeira')

      expect(subject.to_s).to eq 'Cadeira'
    end
  end

  it 'should calculate the estimated total price' do
    expect(subject.estimated_total_price).to eq 0

    subject.quantity = 5
    subject.unit_price = 10.1

    expect(subject.estimated_total_price).to eq 50.5
  end

  it "should without_lot? be true when has not lot" do
    described_class.stub(:without_lot?).and_return(true)
    described_class.should be_without_lot
  end

  it "should without_lot? be false when has not lot" do
    described_class.stub(:without_lot?).and_return(false)
    described_class.should_not be_without_lot
  end

  context 'unit price and total value in a licitation_process' do
    let :bidder do
      double('Bidder', proposals: [proposal])
    end

    let :proposal do
      double('LicitationProcessProposal', id: 1, purchase_process_item: subject, unit_price: 10)
    end

    it 'should return unit price by bidder' do
      expect(subject.unit_price_by_bidder(bidder)).to eq 10
    end

    it 'should return total value by bidder' do
      subject.quantity = 4
      expect(subject.total_value_by_bidder(bidder)).to eq 40
    end

    it 'should return zero when unit price equals nil' do
      proposal.stub(unit_price: nil)
      subject.quantity = 3

      expect(subject.total_value_by_bidder(bidder)).to eq 0
    end
  end

  describe "#winning_bid" do
    it 'returns the classification that has won the bid' do
      classification_1 = double(:classification, situation: SituationOfProposal::LOST)
      classification_2 = double(:classification, situation: SituationOfProposal::WON)

      subject.stub(licitation_process_classifications: [classification_1, classification_2])

      expect(subject.winning_bid).to eq classification_2
    end
  end

  describe '#creditor_winner' do
    let(:purchase_process_item_winner) { double(:purchase_process_item_winner) }

    it 'should return the credito winner for item' do
      purchase_process_item_winner.should_receive(:winner).with(subject).and_return 'creditor'

      expect(subject.creditor_winner(purchase_process_item_winner)).to eq 'creditor'
    end
  end
end
