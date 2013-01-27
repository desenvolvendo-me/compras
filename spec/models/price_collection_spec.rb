# encoding: utf-8
require 'model_helper'
require 'app/models/price_collection'
require 'app/models/price_collection_lot'
require 'app/models/price_collection_proposal'
require 'lib/annullable'
require 'app/models/price_collection_annul'
require 'app/models/price_collection_classification'

describe PriceCollection do
  context 'relationships' do
    it { should belong_to :delivery_location }
    it { should belong_to :employee }
    it { should belong_to :payment_method }
    it { should have_one(:annul) }
    it { should have_many :price_collection_lots }
    it { should have_many(:price_collection_proposals).dependent(:destroy).order(:id) }
    it { should have_many(:creditors).through(:price_collection_proposals) }
    it { should have_many(:items).through(:price_collection_lots) }
    it { should have_many(:price_collection_classifications).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of :year }
    it { should validate_presence_of :date }
    it { should validate_presence_of :delivery_location }
    it { should validate_presence_of :employee }
    it { should validate_presence_of :payment_method }
    it { should validate_presence_of :period }
    it { should validate_presence_of :period_unit }
    it { should validate_presence_of :object_description }
    it { should validate_presence_of :expiration }
    it { should validate_presence_of :proposal_validity }
    it { should validate_presence_of :proposal_validity_unit }
    it { should validate_presence_of :type_of_calculation }

    it { should allow_value('2012').for(:year) }
    it { should_not allow_value('201').for(:year) }
    it { should_not allow_value('a201').for(:year) }

    it { should auto_increment(:code).by(:year) }

    context 'validate date related with today' do
      it { should allow_value(Date.current).for(:date) }

      it { should allow_value(Date.tomorrow).for(:date) }

      it 'should not allow date before today' do
        expect(subject).not_to allow_value(Date.yesterday).for(:date).
                                                      with_message("deve ser igual ou posterior a data atual (#{I18n.l(Date.current)})")
      end
    end

    context 'validate expiration related with today' do
      it { should allow_value(Date.current).for(:expiration) }

      it { should allow_value(Date.tomorrow).for(:expiration) }

      it 'should not allow expiration before today' do
        expect(subject).not_to allow_value(Date.yesterday).for(:expiration).
          with_message("deve ser igual ou posterior a data atual (#{I18n.l(Date.current)})")
      end
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

  context 'lots with items' do
    let :lot_with_items do
      [double("PriceCollectionLot", :items => [double("PriceCollectionLotItem")]),
       double("PriceCollectionLot", :items => [])]
    end

    it 'should filter lots with items' do
      subject.should_receive(:price_collection_lots).and_return(lot_with_items)

      expect(subject.price_collection_lots_with_items.size).to eq 1
    end
  end
end
