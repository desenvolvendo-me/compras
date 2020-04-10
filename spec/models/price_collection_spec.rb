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
    xit { should validate_presence_of :year }
    xit { should validate_presence_of :date }
    xit { should validate_presence_of :delivery_location }
    xit { should validate_presence_of :employee }
    xit { should validate_presence_of :payment_method }
    xit { should validate_presence_of :period }
    xit { should validate_presence_of :period_unit }
    xit { should validate_presence_of :object_description }
    xit { should validate_presence_of :expiration }
    xit { should validate_presence_of :proposal_validity }
    xit { should validate_presence_of :proposal_validity_unit }
    xit { should validate_presence_of :type_of_calculation }

    xit { should allow_value('2012').for(:year) }
    xit { should_not allow_value('201').for(:year) }
    xit { should_not allow_value('a201').for(:year) }

    it { should auto_increment(:code).by(:year) }

    context 'validate date related with today' do
      it { should allow_value(Date.current).for(:date) }

      it { should allow_value(Date.tomorrow).for(:date) }

      xit 'should not allow date before today' do
        expect(subject).not_to allow_value(Date.yesterday).for(:date).
                                                      with_message("deve ser igual ou posterior a data atual (#{I18n.l(Date.current)})")
      end
    end

    context 'validate expiration related with today' do
      it { should allow_value(Date.current).for(:expiration) }

      it { should allow_value(Date.tomorrow).for(:expiration) }

      xit 'should not allow expiration before today' do
        expect(subject).not_to allow_value(Date.yesterday).for(:expiration).
          with_message("deve ser igual ou posterior a data atual (#{I18n.l(Date.current)})")
      end
    end

  end

  xit "should return code_and_year as to_s method" do
    subject.stub(:code => 5, :year => 2012)

    expect(subject.to_s).to eq '5/2012'
  end

  xit 'should return the winner proposal' do
    proposal_1 = double('proposal_1', :total_price => 500)
    proposal_2 = double('proposal_2', :total_price => 300)

    subject.stub(:price_collection_proposals => [proposal_1, proposal_2])

    expect(subject.winner_proposal).to eq proposal_2
  end

  xit 'should return the full period' do
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

  describe "#validate_quantity_of_creditors" do
    xit "when returns 2 creditors" do
      subject.stub(:proposals_count).and_return(2)
      subject.valid?

      expect(subject.errors[:base]).to include "deve ter no mínimo três fornecedores"
    end

    xit "when returns 4 creditors" do
      subject.stub(:proposals_count).and_return(4)
      subject.valid?

      expect(subject.errors[:base]).to_not include "deve ter no mínimo três fornecedores"
    end
  end

  xit 'should have at least one item' do
    expect(subject.items).to be_empty

    subject.valid?

    expect(subject.errors[:items]).to include 'é necessário cadastrar pelo menos um item'
  end

  xit 'should have at least one item without considering the marked for destruction ones' do
    item_marked_for_destruction = double('item', :material_id => 1, :marked_for_destruction? => true)

    subject.stub(:items).and_return([item_marked_for_destruction])

    subject.valid?

    expect(subject.errors[:items]).to include 'é necessário cadastrar pelo menos um item'
  end
end
