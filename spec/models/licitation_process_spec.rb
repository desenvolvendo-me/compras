require 'model_helper'
require 'lib/signable'
require 'app/models/persona/person'
require 'app/models/person'
require 'app/models/persona/creditor'
require 'app/models/budget_structure'
require 'app/models/expense_nature'
require 'app/models/budget_allocation'
require 'app/models/budget_structure'
require 'app/models/licitation_process'
require 'app/models/payment_method'
# require 'app/models/purchase_process_budget_allocation'
require 'app/models/purchase_process_item'
require 'app/models/licitation_process_publication'
require 'app/models/bidder'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process_appeal'
require 'app/models/licitation_process_ratification'
require 'app/models/budget_allocation'
require 'app/models/budget_structure'
require 'app/models/pledge'
require 'app/models/judgment_commission_advice'
require 'app/models/creditor'
require 'app/models/licitation_notice'
require 'app/models/indexer'
require 'app/models/purchase_solicitation_item'
require 'app/models/legal_analysis_appraisal'
require 'app/models/purchase_process_accreditation'
require 'app/models/purchase_process_creditor_proposal'
require 'app/models/purchase_process_creditor_disqualification'
require 'app/models/purchase_process_trading'
require 'app/models/process_responsible'
require 'app/models/realignment_price'
require 'app/models/modality_limit'
require 'app/models/purchase_process_fractionation'
require 'app/business/purchase_process_proposal_envelope_opening_date_calculator'
require 'app/business/modality_limit_chooser'

describe LicitationProcess do
  let(:current_prefecture) { double(:current_prefecture) }

  before do
    subject.stub(:current_prefecture => current_prefecture)
    current_prefecture.stub(:allow_insert_past_processes => true)
  end

  describe '#to_s' do
    before do
      subject.process = 1
      subject.year = 2012
      subject.modality_number = 1
    end
  #
    context 'when has modality' do
      before { subject.stub(modality_humanize: 'Pregão') }

      it { expect(subject.to_s).to eq '1/2012 - Pregão 1' }
    end

    context 'when has type_of_removal' do
      before { subject.stub(type_of_removal_humanize: 'Compra Direta') }

      it { expect(subject.to_s).to eq '1/2012 - Compra Direta 1' }
    end
  end

  it { should belong_to :contact }
  it { should belong_to :judgment_form }
  it { should belong_to :payment_method }
  it { should belong_to :readjustment_index }

  it { should have_many(:purchase_solicitations) }
  it { should have_many(:licitation_notices).dependent(:destroy) }
  it { should have_many(:publications).dependent(:destroy).order(:id) }
  it { should have_many(:bidders).dependent(:destroy).order(:id) }
  it { should have_many(:licitation_process_impugnments).dependent(:restrict).order(:id) }
  it { should have_many(:licitation_process_appeals).dependent(:restrict) }
  it { should have_many(:license_creditors).dependent(:restrict).through(:bidders) }
  it { should have_many(:accreditation_creditors).through(:purchase_process_accreditation) }
  it { should have_many(:licitation_process_ratifications).dependent(:restrict) }
  it { should have_many(:ratifications_items).through(:licitation_process_ratifications) }
  it { should have_many(:licitation_process_ratification_creditors).through(:licitation_process_ratifications).order(:id) }
  it { should have_many(:classifications).through(:bidders) }
  it { should have_many(:purchase_process_budget_allocations).dependent(:destroy) }
  it { should have_many(:items).dependent(:restrict)}
  it { should have_many(:materials).through(:items) }
  it { should have_many(:legal_analysis_appraisals).dependent(:restrict) }
  it { should have_many(:creditor_proposals) }
  it { should have_many(:tied_creditor_proposals) }
  it { should have_many(:realignment_prices) }
  it { should have_many(:items_creditors).through(:items) }
  it { should have_many(:creditor_disqualifications).dependent(:restrict) }
  it { should have_many(:process_responsibles).dependent(:restrict) }
  it { should have_many(:trading_items).through(:trading) }
  it { should have_many(:trading_item_bids).through(:trading_items) }
  it { should have_many(:trading_item_negotiations).through(:trading_items) }
  it { should have_many(:fractionations).dependent(:destroy) }

  it { should have_one(:judgment_commission_advice).dependent(:restrict) }
  it { should have_one(:purchase_process_accreditation).dependent(:restrict) }
  it { should have_one(:trading).dependent(:restrict) }

  it { should validate_presence_of :contract_guarantees }
  it { should validate_presence_of :description }
  it { should validate_presence_of :execution_type }
  it { should validate_presence_of :object_type }
  it { should validate_presence_of :payment_method }
  it { should validate_presence_of :period }
  it { should validate_presence_of :period_unit }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :type_of_purchase }
  it { should validate_presence_of :year }
  it { should validate_duplication_of(:ranking).on(:tied_creditor_proposals) }

  it { should_not validate_presence_of :proposal_envelope_opening_date }
  it { should_not validate_presence_of :proposal_envelope_opening_time }
  it { should_not validate_presence_of :modality }
  it { should_not validate_presence_of :judgment_form_id }
  it { should_not validate_presence_of :type_of_removal }
  it { should_not validate_presence_of :goal }
  it { should_not validate_presence_of :licensor_rights_and_liabilities }
  it { should_not validate_presence_of :licensee_rights_and_liabilities }

  it { should validate_numericality_of :budget_allocation_year }

  it { should delegate(:lot?).to(:judgment_form).allowing_nil(true).prefix(true) }
  it { should delegate(:item?).to(:judgment_form).allowing_nil(true).prefix(true) }
  it { should delegate(:global?).to(:judgment_form).allowing_nil(true).prefix(true) }
  it { should delegate(:licitation_kind).to(:judgment_form).allowing_nil(true).prefix(true) }
  it { should delegate(:best_technique?).to(:judgment_form).allowing_nil(true).prefix(true) }
  it { should delegate(:technical_and_price?).to(:judgment_form).allowing_nil(true).prefix(true) }
  it { should delegate(:best_auction_or_offer?).to(:judgment_form).allowing_nil(true).prefix(true) }
  it { should delegate(:higher_discount_on_table?).to(:judgment_form).allowing_nil(true).prefix(true) }
  it { should delegate(:lowest_price?).to(:judgment_form).allowing_nil(true).prefix(true) }
  it { should delegate(:higher_discount_on_lot?).to(:judgment_form).allowing_nil(true).prefix(true) }
  it { should delegate(:higher_discount_on_item?).to(:judgment_form).allowing_nil(true).prefix(true) }

  describe 'default values' do
    it 'total_value_of_items should be 0.0' do
      expect(subject.total_value_of_items).to eq BigDecimal('0.0')
    end

    it 'budget_allocations_total_value should be 0.0' do
      expect(subject.budget_allocations_total_value).to eq BigDecimal('0.0')
    end
  end

  describe '#modality_or_type_of_removal' do
    context 'when has a modality' do
      before do
        subject.stub(:modality_number).and_return(1)
        subject.stub(:modality_humanize).and_return('Pregão')
      end

      it 'returns number and modality' do
        expect(subject.modality_or_type_of_removal).to eql '1 - Pregão'
      end
    end

    context 'when has a type of removal' do
      before do
        subject.stub(:modality_number).and_return(1)
        subject.stub(:modality_humanize).and_return(nil)
        subject.stub(:type_of_removal_humanize).and_return('Afastamento')
      end

      it 'returns number and modality' do
        expect(subject.modality_or_type_of_removal).to eql '1 - Afastamento'
      end
    end
  end

  context 'validations' do
    it 'should not allow year greater than to budget_allocation_year' do
      subject.year = 2013
      subject.budget_allocation_year = 2012

      subject.valid?

      expect(subject.errors[:budget_allocation_year]).to include('deve ser maior ou igual a 2013')
    end
  end

  context "when is a licitation" do
    before do
      subject.type_of_purchase = PurchaseProcessTypeOfPurchase::LICITATION
    end

    it { should validate_presence_of :modality }
    it { should validate_presence_of :judgment_form_id }
    it { should validate_presence_of :envelope_delivery_date }
    it { should validate_presence_of :envelope_delivery_time }
    it { should validate_presence_of :expiration }
    it { should validate_presence_of :expiration_unit }
  end

  context "when is a licitation" do
    before do
      subject.object_type = PurchaseProcessObjectType::PERMITS
    end

    it { should validate_presence_of :goal }
    it { should validate_presence_of :licensor_rights_and_liabilities }
    it { should validate_presence_of :licensee_rights_and_liabilities }
  end

  context "when is a direct purchase" do
    before do
      subject.type_of_purchase = PurchaseProcessTypeOfPurchase::DIRECT_PURCHASE
    end

    it { should validate_presence_of :type_of_removal }
    it { should validate_presence_of :justification }
    it { should validate_presence_of :justification_and_legal }
  end
  #
  context "when updating a record" do
    before do
      subject.stub(:validation_context).and_return(:update)
    end

    context "model validations" do
      before do
        subject.stub(:validate_proposal_envelope_opening_date).and_return true
      end

      it { should allow_value("11:11").for(:proposal_envelope_opening_time) }

      describe 'proposal_envelope_opening_date' do
        before do
          subject.type_of_purchase = PurchaseProcessTypeOfPurchase::LICITATION
        end

        context 'when proposal envelope opening date before calculated' do
          it "should have error" do
            subject.proposal_envelope_opening_date = Date.current
            subject.stub(last_publication_date: Date.current)
            subject.stub(:validation_context).and_return(:update)

            PurchaseProcessProposalEnvelopeOpeningDateCalculator.
              should_receive(:calculate).
              with(subject).
              and_return(Date.tomorrow)

            subject.valid?

            expect(subject.errors[:proposal_envelope_opening_date]).to include("deve ser em ou depois de #{I18n.l Date.tomorrow}")
          end
        end
      end

        context 'when proposal envelope opening date on calculated' do
          it "should not have an error" do
            subject.proposal_envelope_opening_date = Date.current
            subject.stub(last_publication_date: Date.current)
            subject.stub(:validation_context).and_return(:update)

            PurchaseProcessProposalEnvelopeOpeningDateCalculator.
              should_receive(:calculate).
              with(subject).
              and_return(Date.current)

            subject.valid?

            #TODO: depende de PO
            expect(subject.errors[:proposal_envelope_opening_date]).to_not include("deve ser em ou depois de #{I18n.l Date.current}")
          end
        end

        context 'when proposal envelope opening date after calculated' do
          it "should not have an error" do
            subject.proposal_envelope_opening_date = Date.current
            subject.stub(last_publication_date: Date.current)
            subject.stub(:validation_context).and_return(:update)

            PurchaseProcessProposalEnvelopeOpeningDateCalculator.
              should_receive(:calculate).
              with(subject).
              and_return(Date.yesterday)

            subject.valid?

            #TODO: depende de PO
            expect(subject.errors[:proposal_envelope_opening_date]).to_not include("deve ser em ou depois de #{I18n.l Date.yesterday}")
          end
        end
      end
    # end
  #
    describe "#validate_proposal_envelope_opening_date" do
      before do
        subject.type_of_purchase = PurchaseProcessTypeOfPurchase::LICITATION
      end

      it "return when envelope opening date is not present" do
        subject.stub(:proposal_envelope_opening_date).and_return nil
        subject.send(:validate_proposal_envelope_opening_date)
        expect(subject.errors[:proposal_envelope_opening_date]).to_not include("deve ficar em branco")
      end

      it "envelope opening date should be blank when has not a publication" do
        subject.stub(:proposal_envelope_opening_date).and_return Date.current
        subject.stub(:last_publication_date).and_return nil

        subject.send(:validate_proposal_envelope_opening_date)
        expect(subject.errors[:proposal_envelope_opening_date]).to include("deve ficar em branco")
      end
    end

    describe '#creditors' do
      context 'when direct purchase' do
        before { subject.stub(:direct_purchase?).and_return true }

        it 'returns creditors from items' do
          subject.should_receive(:items_creditors).and_return(['creditor'])
          subject.should_not_receive(:license_creditors)

          expect(subject.creditors).to eql ['creditor']
        end
      end

      context 'when modality is not trading' do
        before { subject.stub(:trading?).and_return false }

        it 'returns creditors from license_creditors' do
          subject.should_receive(:license_creditors).and_return(['creditor'])
          subject.should_not_receive(:items_creditors)

          expect(subject.creditors).to eq ['creditor']
        end
      end

      context 'when modality trading' do
        before { subject.stub(:trading?).and_return true }

        it 'returns creditors from accreditation_creditors' do
          subject.should_receive(:accreditation_creditors).and_return(['creditor'])
          subject.should_not_receive(:license_creditors)

          expect(subject.creditors).to eql ['creditor']
        end
      end
    end

    describe '#creditors_enabled' do
      context 'when trading' do
        before { subject.stub(:trading?).and_return true }

        it 'should return the creditors' do
          subject.should_receive(:creditors).and_return ['creditor']

          expect(subject.creditors_enabled).to eq ['creditor']
        end
      end

      context 'when not trading' do
        let(:creditors) { double(:creditors) }

        before { subject.stub(:trading?).and_return false }

        it 'should return the creditors scoped by enabled_or_benefited' do
          subject.should_receive(:creditors).and_return creditors
          creditors.should_receive(:enabled_or_benefited_by_purchase_process_id).and_return ['creditor']

          expect(subject.creditors_enabled).to eq ['creditor']
        end
      end
    end

    describe "#validate_the_year_to_processe_date_are_the_same" do
      context 'when process_date_year is equals to year' do
        before do
          subject.stub(:process_date_year => 2013)
          subject.stub(:year => 2013)
        end

        it 'should be valid' do
          subject.valid?

          expect(subject.errors[:process_date]).to_not include('não pode trocar o ano da data de expedição')
        end
      end

      context 'when process_date_year is not equals to year' do
        before do
          subject.stub(:process_date => 2013)
          subject.stub(:year => 2012)
        end

        it 'should not be valid' do
          expect(subject).to_not be_valid

          expect(subject.errors[:process_date]).to include('não pode trocar o ano da data de expedição')
        end
      end
    end
  # end
  #
  describe '#process_date_year' do
    context 'when process_date is nil' do
      it 'should return nil' do
        expect(subject.process_date_year).to be_nil
      end
    end
    end

    context 'when process_date is not nil' do
      it 'should return the year of process_date' do
        subject.process_date = Date.new(2013, 10, 10)

        expect(subject.process_date_year).to eq 2013
      end
    end
  end

  describe "#concessions_or_permits?" do
    context "when object_type is concession" do
      it "should return true" do
        subject.object_type = PurchaseProcessObjectType::CONCESSIONS

        expect(subject.concessions_or_permits?).to be_true
      end
    end

    context "when object_type is permits" do
      it "should return true" do
        subject.object_type = PurchaseProcessObjectType::PERMITS

        expect(subject.concessions_or_permits?).to be_true
      end
    end
  end

  context 'new_proposal_envelope_opening_date is not equal to new_envelope_delivery_date' do
    before do
      subject.type_of_purchase = PurchaseProcessTypeOfPurchase::LICITATION
    end

    it { should allow_value("11:11").for(:envelope_delivery_time) }
    it { should_not allow_value("44:11").for(:envelope_delivery_time) }
  end

  context 'when prefecture allow_insert_past_processes is true' do
    context 'validate envelope_delivery_date related with today' do
      it { should allow_value(Date.current).for(:envelope_delivery_date) }

      it { should allow_value(Date.tomorrow).for(:envelope_delivery_date) }

      it 'should allow envelope_delivery_date before today' do
        expect(subject).to allow_value(Date.yesterday).for(:envelope_delivery_date)
      end
    end
  end

  context 'when prefecture allow_insert_past_processes is false' do
    before do
      subject.stub(:current_prefecture => current_prefecture)
      current_prefecture.stub(:allow_insert_past_processes => false)
    end

    context 'validate envelope_delivery_date related with today' do
      it { should allow_value(Date.current).for(:envelope_delivery_date) }

      it { should allow_value(Date.tomorrow).for(:envelope_delivery_date) }

      it 'should not allow envelope_delivery_date before today' do
        expect(subject).not_to allow_value(Date.yesterday).for(:envelope_delivery_date).
                                                      with_message("deve ser igual ou posterior a data atual (#{I18n.l(Date.current)})")
      end
    end
  end

  context 'validate proposal_envelope_opening_date related with envelope_delivery_date' do
    let :envelope_delivery_date do
      Date.current + 10.days
    end

    before do
      subject.stub(:envelope_delivery_date).and_return(envelope_delivery_date)
    end

    it 'should allow proposal_envelope_opening_date date after envelope_delivery_date' do
      expect(subject).to allow_value(Date.current + 15.days).for(:proposal_envelope_opening_date)
    end

    it 'should allow proposal_envelope_opening_date date equals to envelope_delivery_date' do
      expect(subject).to allow_value(envelope_delivery_date).for(:proposal_envelope_opening_date)
    end

    it 'should not allow proposal_envelope_opening_date date before envelope_delivery_date' do
      expect(subject).not_to allow_value(Date.current).for(:proposal_envelope_opening_date).
                                                    with_message("deve ser igual ou posterior a data da entrega dos envelopes (#{I18n.l envelope_delivery_date})")
    end
  end

  context '#validate_bidders_before_edital_publication' do
    it "when bidders where added before publication and is a licitation" do
      subject.stub(:bidders => [double], licitation?: true )

      subject.valid?

      expect(subject.errors[:base]).to include "Habilitações não podem ser incluídos antes da publicação do edital"
    end

    it "when bidders where added before publication and is a direct purchase" do
      subject.stub(:bidders => [double], licitation?: false )

      subject.valid?

      expect(subject.errors[:base]).to_not include "Habilitações não podem ser incluídos antes da publicação do edital"
    end
  end

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201').for(:year) }
  it { should_not allow_value('a201').for(:year) }

  it "validate attribute changes if not updateable" do
    subject.stub(:updateable? => false)
    subject.year = 2014

    subject.valid?

    expect(subject.errors[:base]).to include "não pode ser editado"
  end

  context "when proposal_envelope_opening_date is not the current date" do
    it "should return false for envelope_opening? method" do
      subject.proposal_envelope_opening_date = Date.tomorrow

      expect(subject).not_to be_envelope_opening
    end
  end

  context "when proposal_envelope_opening_date is the current date" do
    it "should return true for envelope_opening? method" do
      subject.proposal_envelope_opening_date = Date.current

      expect(subject).to be_envelope_opening
    end
  end

  context 'has bidders and is available for classification' do
    it 'should return true' do
      subject.stub(:bidders => [double])
      subject.stub(:available_for_licitation_process_classification? => true)

      expect(subject.has_bidders_and_is_available_for_classification).to be true
    end

    it 'should return false' do
      subject.stub(:bidders => [])
      subject.stub(:available_for_licitation_process_classification? => true)

      expect(subject.has_bidders_and_is_available_for_classification).to be false
    end

    it 'should return false' do
      subject.stub(:bidders => [double])
      subject.stub(:available_for_licitation_process_classification? => false)

      expect(subject.has_bidders_and_is_available_for_classification).to be false
    end
  end

  context "#winning_bid" do
    it 'returns the classification that has won the bid' do
      classification_1 = double(:classification, :situation => SituationOfProposal::LOST)
      classification_2 = double(:classification, :situation => SituationOfProposal::WON)

      subject.stub(:all_licitation_process_classifications => [classification_1, classification_2])

      expect(subject.winning_bid).to eq classification_2
    end
  end

  describe "#edital_published?" do
    it "returns true if there are any published editals" do
      publications = double(:edital => [double])
      subject.stub(:publications => publications)

      expect(subject.edital_published?).to be_true
    end
  end

  describe "#updateable" do

    let(:ratifications) { double(:empty? => true) }

    let(:publications) do
      double(:empty? => true,
             :current_updateable? => true)
    end

    before do
      subject.stub(:publications => publications)
      subject.stub(:licitation_process_ratifications => ratifications)
      subject.stub(:new_record? => false)
    end

    it "returns true if it's a new record" do
      subject.stub(:new_record? => true)

      expect(subject).to be_updateable
    end

    it "returns true if there are no ratifications" do
      ratifications.stub(:empty? => true)
      publications.stub(:current_updateable? => true)

      expect(subject).to be_updateable
    end

    it "returns true if publications are updateable" do
      publications.stub(:current_updateable? => true)

      expect(subject).to be_updateable
    end

    it "returns false otherwise" do
      publications.stub(:current_updateable? => false,
                        :empty? => false)
      ratifications.stub(:empty? => false)

      expect(subject).not_to be_updateable
    end
  end

  describe '#ratification?' do
    it 'should be true when have any licitation_process_ratifications' do
      subject.stub(:licitation_process_ratifications).and_return(['ratification'])

      expect(subject.ratification?).to be_true
    end

    it 'should be false when have anyone licitation_process_ratifications' do
      subject.stub(:licitation_process_ratifications).and_return([])

      expect(subject.ratification?).to be_false
    end
  end

  describe '#update_status' do
    it 'should update status' do
      subject.should_receive(:update_column).with(:status, PurchaseProcessStatus::IN_PROGRESS)

      subject.update_status(PurchaseProcessStatus::IN_PROGRESS)
    end
  end

  describe '#has_trading?' do
    context 'when trading is not present' do
      it { expect(subject.has_trading?).to be_false }
    end

    context 'when trading is present' do
      let(:trading) { double(:trading) }

      before do
        subject.stub(:trading => trading)
      end

      it { expect(subject.has_trading?).to be_true }
    end
  end

  describe "#last_publication_date" do
    let(:current_publication) { double :current_publication, publication_date: Date.tomorrow }

    before { subject.stub(:current_publication).and_return current_publication }

    it "returns the publication date from the last publication" do
      expect(subject.last_publication_date).to eql Date.tomorrow
    end
  end

  describe '#current_publication' do
    let(:publications) { double :publications }

    before do
      subject.stub(:publications).and_return publications
      publications.should_receive(:empty?).and_return false
    end

    it 'returns the current licitation process publication' do
      publications.should_receive(:current)
      subject.current_publication
    end
  end

  describe '#update_purchase_solicitation_to_purchase_process' do
    let(:purchase_solicitation) { double(:purchase_solicitation) }

    before do
      subject.stub(:valid?).and_return true
      subject.stub(:purchase_solicitations).and_return [purchase_solicitation]
    end

    it "updates the purchase solicitation service_status to in_purchase_process" do
      purchase_solicitation.should_receive(:buy!)
      subject.send(:update_purchase_solicitation_to_purchase_process, purchase_solicitation)
    end
  end

  describe '#update_purchase_solicitation_to_liberated' do
    let(:purchase_solicitation) { double(:purchase_solicitation) }

    it "updates the purchase solicitation service_status to liberated" do
      subject.stub(:valid?).and_return true
      purchase_solicitation.should_receive(:liberate!)
      subject.send(:update_purchase_solicitation_to_liberated, purchase_solicitation)
    end
  end

  describe '#each_item_lot' do
    let(:item1) { double(:item, lot: 1) }
    let(:item2) { double(:item, lot: 1) }
    let(:item3) { double(:item, lot: 2) }

    before do
      subject.stub(:items).and_return([item1, item2, item3])
    end

    it 'returns the unique item lots yielded' do
      subject.should_receive(:each_item_lot).and_yield(3).and_yield(2)

      subject.each_item_lot { |p| }
    end
  end

  describe '#proposals_of_creditor' do
    let(:creditor)  { double :creditor, id: 1 }
    let(:proposals) { double :creditor_proposals }

    before do
      subject.stub(:id).and_return 1
      subject.stub(creditor_proposals: proposals)
    end

    it 'returns the creditor proposals of the creditor parameter' do
      proposals.
        should_receive(:creditor_id).
        with(creditor.id).and_return(proposals)

      proposals.should_receive(:order).with(:id)

      subject.proposals_of_creditor(creditor)
    end
  end

  describe '#proposals_total_price' do
    let(:proposal_1) { double(:proposal, total_price: 15.10) }
    let(:proposal_2) { double(:proposal, total_price: 1.10) }
    let(:proposals)  { [proposal_1, proposal_2] }

    it 'returns proposals total price for the given creditor' do
      subject.stub(:proposals_of_creditor).and_return(proposals)

      expect(subject.proposals_total_price(double(:creditor))).to eql 16.20
    end
  end

  describe 'when save' do
    describe "and has not items" do
      it "total_value_of_items= has not called" do
        subject.stub(:items).and_return(nil)
        subject.should_not_receive(:total_value_of_items=)

        subject.run_callbacks(:save)
      end
    end

    describe "and has items" do
      let(:items) { [item1, item2, item3] }

      let(:item1) do
        double(:items1,
               :marked_for_destruction? => true,
               :estimated_total_price => 100
              )
      end

      let(:item2) do
        double(:items2,
               :marked_for_destruction? => false,
               :estimated_total_price => 50
              )
      end

      let(:item3) do
        double(:items3,
               :marked_for_destruction? => false,
               :estimated_total_price => 10
              )
      end

      it "should return tota_value_of_items" do
        subject.stub(:items).and_return(items)

        subject.run_callbacks(:save)

        expect(subject.calculate_total_value_of_items.to_i).to eq 60
      end
    end

    describe "and not has budget allocations" do
      it "budget_allocations_total_value= has not called" do
        subject.stub(:purchase_process_budget_allocations).and_return([])
        subject.should_not_receive(:budget_allocations_total_value=)

        subject.run_callbacks(:save)
      end
    end

    describe "and has budget allocations" do
      let(:budget_allocation1) do
        double(:budget_allocation1,
               :marked_for_destruction? => false,
               :value => 5
              )
      end

      let(:budget_allocation2) do
        double(:budget_allocation2,
               :marked_for_destruction? => true,
               :value => 10
              )
      end

      let(:budget_allocation3) do
        double(:budget_allocation3,
               :marked_for_destruction? => false,
               :value => 5
              )
      end

      it "should return budget_allocations_total_value" do
        subject.stub(:purchase_process_budget_allocations).and_return([budget_allocation1, budget_allocation2, budget_allocation3])
        subject.run_callbacks(:save)

        expect(subject.calculate_budget_allocations_total_value.to_i).to eq 10
      end
    end
  end

  describe '#allow_trading_auto_creation?' do
    context 'when not persisted' do
      it { expect(subject.allow_trading_auto_creation?).to be_false }
    end

    context 'when is not trading' do
      before do
        subject.stub(:persisted? => true, :trading? => false)
      end

      it { expect(subject.allow_trading_auto_creation?).to be_false }
    end

    context 'when has trading' do
      before do
        subject.stub(:persisted? => true, :trading? => true, :has_trading? => true)
      end

      it { expect(subject.allow_trading_auto_creation?).to be_false }
    end

    context 'when has no trading' do
      before do
        subject.stub(:persisted? => true, :trading? => true, :has_trading? => false)
      end

      it { expect(subject.allow_trading_auto_creation?).to be_true }
    end
  end

  describe '#all_proposals_given?' do
    context 'when judgment_form is by item' do
      before do
        subject.stub(judgment_form_kind: JudgmentFormKind::ITEM)
      end

      context 'when the number of proposals are equal to creditors * items' do
        before do
          subject.stub(creditor_proposals: ['p1', 'p2', 'p3', 'p4'])
          subject.stub(creditors: ['c1', 'c2'])
          subject.stub(items: ['i1', 'i2'])
        end

        it { expect(subject.all_proposals_given?).to be_true }
      end

      context 'when the number of proposals are not equal to creditors * items' do
        before do
          subject.stub(creditor_proposals: ['p1', 'p2', 'p3'])
          subject.stub(creditors: ['c1', 'c2'])
          subject.stub(items: ['i1', 'i2'])
        end

        it { expect(subject.all_proposals_given?).to be_false }
      end
    end

    context 'when judgment_form is by lot' do
      let(:items) { double(:items) }

      before do
        subject.stub(judgment_form_kind: JudgmentFormKind::LOT)
      end

      context 'when the number of proposals are equal to creditors * lots' do
        before do
          subject.stub(creditor_proposals: ['p1', 'p2', 'p3', 'p4'])
          subject.stub(creditors: ['c1', 'c2'])
          subject.stub(items: items)
          items.stub(lots: ['l1', 'l2'])
        end

        it { expect(subject.all_proposals_given?).to be_true }
      end

      context 'when the number of proposals are not equal to creditors * lots' do
        before do
          subject.stub(creditor_proposals: ['p1', 'p2', 'p3'])
          subject.stub(creditors: ['c1', 'c2'])
          subject.stub(items: items)
          items.stub(lots: ['l1', 'l2'])
        end

        it { expect(subject.all_proposals_given?).to be_false }
      end
    end

    context 'when judgment_form is global' do
      before do
        subject.stub(judgment_form_kind: JudgmentFormKind::GLOBAL)
      end

      context 'when the number of proposals are equal to creditors' do
        before do
          subject.stub(creditor_proposals: ['p1', 'p2'])
          subject.stub(creditors: ['c1', 'c2'])
        end

        it { expect(subject.all_proposals_given?).to be_true }
      end

      context 'when the number of proposals are not equal to creditors' do
        before do
          subject.stub(creditor_proposals: ['p1'])
          subject.stub(creditors: ['c1', 'c2'])
        end

        it { expect(subject.all_proposals_given?).to be_false }
      end
    end
  end

  describe '#published_editals' do
    it 'should return the publications of kind edital' do
      publications = double(:publications)
      subject.should_receive(:publications).and_return publications
      publications.should_receive(:edital).and_return ['edital']

      expect(subject.published_editals).to eq ['edital']
    end
  end

  describe '#budget_allocations' do
    before do
      subject.stub :purchase_process_budget_allocations => [purchase_process_budget_allocation]
    end

    let :purchase_process_budget_allocation do
      double(:purchase_process_budget_allocation, :budget_allocation => budget_allocation)
    end

    let :budget_allocation do
      double(:budget_allocation)
    end

    it 'delegates to purchase_process_budget_allocations' do
      expect(subject.budget_allocations).to eq [budget_allocation]
    end

    context 'when purchase_process_budget_allocations is nil' do
      before do
        subject.stub :purchase_process_budget_allocations => nil
      end

      it 'returns nil' do
        expect(subject.budget_allocations).to be_nil
      end
    end
  end

  describe '#reserve_funds' do
    let(:repository) { double(:reserve_fund_repository) }

    it "should return all purchase_process's reserve_funds" do
      subject.id = 55

      repository.
        should_receive(:all).
        with(params: { by_purchase_process_id: 55} ).
        and_return(['reserve_fund'])

      expect(subject.reserve_funds(repository)).to eq ['reserve_fund']
    end
  end

  describe '#budget_allocation_capabilities' do
    before do
      subject.stub :budget_allocations => [budget_allocation]
    end

    let :budget_allocation do
      double(:budget_allocation_capabilities => [])
    end

    it 'delegates to budget_allocations' do
      expect(subject.budget_allocation_capabilities).to eq []
    end

    context 'when budget_allocations is nil' do
      before do
        subject.stub :budget_allocations => nil
      end

      it 'returns nil' do
        expect(subject.budget_allocation_capabilities).to be_nil
      end
    end
  end

  describe '#reserve_funds_available' do
    it 'should return the reserve funds for the purchase_process without pledge' do
      subject.id = 5
      repository = double(:reserve_fund_repository)

      repository.should_receive(:all).with(params: { by_purchase_process_id: 5, without_pledge: true })

      subject.reserve_funds_available(repository)
    end
  end

  describe 'validate_budget_allocations_destruction' do
    context 'when has budget_allocations marked_for_destruction' do
      let(:purchase_process_budget_allocations) { double(:purchase_process_budget_allocations) }
      let(:budget_allocation) { double(:budget_allocation, to_s: 'allocation') }

      let :purchase_process_budget_allocation do
        double(:purchase_process_budget_allocation,
          budget_allocation: budget_allocation)
      end

      context 'when budget_allocation can be used' do
        it 'should verify all budget_allocation marked for destruction and do nothing' do
          budget_allocation.stub(can_be_used?: true)
          subject.stub(purchase_process_budget_allocations: purchase_process_budget_allocations)

          purchase_process_budget_allocations.
            stub(:select).
            and_return([purchase_process_budget_allocation])

          purchase_process_budget_allocations.should_not_receive(:reload)

          subject.valid?

          expect(subject.errors[:base]).to_not include('Dotação allocation não pode ser apagada pois já está em uso')
        end
      end
    end
  end

  describe '#destroy_fractionations!' do
    it 'should destroy all fractionations' do
      fractionations = double(:fractionations)

      subject.stub(fractionations: fractionations)

      fractionations.should_receive(:destroy_all)

      subject.destroy_fractionations!
    end
  end
end
