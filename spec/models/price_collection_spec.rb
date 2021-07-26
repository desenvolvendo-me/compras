require 'model_helper'
require 'app/models/price_collection'
require 'app/models/price_collection_item'
require 'app/models/price_collection_proposal'
require 'lib/annullable'
require 'app/models/price_collection_annul'
require 'app/models/price_collection_classification'

describe PriceCollection do
  context 'relationships' do
    it { should belong_to :delivery_location }
    it { should belong_to :employee }
    it { should belong_to :payment_method }

    it { should have_one :annul }

    it { should have_many :items }
    it { should have_many(:price_collection_proposals).dependent(:destroy).order(:id) }
    it { should have_many(:creditors).through(:price_collection_proposals) }
    it { should have_many(:price_collection_classifications).dependent(:destroy) }
    it { should have_and_belong_to_many(:purchase_solicitations) }
  end

  context 'validations' do

    it { should allow_value('2012').for(:year) }

    it { should auto_increment(:code).by(:year) }

    context 'validate date related with today' do
      it { should allow_value(Date.current).for(:date) }

      it { should allow_value(Date.tomorrow).for(:date) }
    end

    context 'validate expiration related with today' do
      it { should allow_value(Date.current).for(:expiration) }

      it { should allow_value(Date.tomorrow).for(:expiration) }
    end

  end

  it "should return code_and_year as to_s method" do
    subject.stub(:code => 5, :year => 2012)

    expect(subject.to_s).to eq '5/2012'
  end

  it 'should return the winner proposal' do
    proposal_1 = double('proposal_1', :total_price => 500)
    proposal_2 = double('proposal_2', :total_price => 300)

    subject.stub(:price_collection_proposals => [proposal_1, proposal_2])

    expect(subject.winner_proposal).to eq proposal_2
  end

  it 'should return the full period' do
    subject.period = 10
    subject.stub(:period_unit_humanize).and_return('dias')

    expect(subject.full_period).to eq '10 dias'
  end

  describe '#annul!' do
    it 'should change the subject status to annuled' do
      subject.should_receive(:update_column).with(:status, PriceCollectionStatus::ANNULLED)

      subject.annul!
    end
  end
end
