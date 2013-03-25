# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_decorator'

describe LicitationProcessDecorator do
  let :time do
    Time.new(2012, 1, 4, 10)
  end

  let :judgment_form do
    double(:judgment_form,
           :lowest_price? => true,
           :item? => false,
           :lot? => false,
           :global? => false)
  end

  context '#envelope_delivery_time' do
    context 'when do not have envelope_delivery_time' do
      before do
        component.stub(:envelope_delivery_time).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.envelope_delivery_time).to be_nil
      end
    end

    context 'when have envelope_delivery_time' do
      before do
        component.stub(:envelope_delivery_time).and_return(time)
      end

      it 'should localize envelope_delivery_time' do
        expect(subject.envelope_delivery_time).to eq '10:00'
      end
    end
  end

  context '#proposal_envelope_opening_time' do
    context 'when do not have proposal_envelope_opening_time' do
      before do
        component.stub(:proposal_envelope_opening_time).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.proposal_envelope_opening_time).to be_nil
      end
    end

    context 'when have proposal_envelope_opening_time' do
      before do
        component.stub(:proposal_envelope_opening_time).and_return(time)
      end

      it 'should return localized opening_delivery_time' do
        expect(subject.proposal_envelope_opening_time).to eq '10:00'
      end
    end
  end

  describe "edit_path" do
    let(:routes) { double(:routes) }

    before do
      routes.stub(:edit_licitation_process_path).with(component).and_return('licitation_process_link')
    end

    context "licitation process has a 'trading' modality" do

      before do
        component.stub(:trading? => true)
      end

      it "returns the associated trading path if it exists" do
        trading = double(:trading)
        routes.stub(:edit_trading_path).with(trading).and_return('trading_link')
        component.stub(:trading => trading)

        expect(subject.edit_path(routes)).to eq 'trading_link'
      end

      it "returns the licitation process path if there is no associated trading" do
        component.stub(:trading => nil)

        expect(subject.edit_path(routes)).to eq 'licitation_process_link'
      end
    end

    it "returns the licitation process type otherwise" do
      component.stub(:trading? => false)

      expect(subject.edit_path(routes)).to eq 'licitation_process_link'
    end
  end

  describe "edit_link" do

    context "licitation process has a 'trading' modality" do

      before do
        component.stub(:trading? => true)
      end

      it "returns 'Voltar ao pregão presencial' if there is a associated trading" do
        trading = double(:trading)
        component.stub(:trading => trading)

        expect(subject.edit_link).to eq 'Voltar ao pregão presencial'
      end

      it "returns 'Voltar ao processo de compra' if there is no associated trading" do
        component.stub(:trading => nil)

        expect(subject.edit_link).to eq 'Voltar ao processo de compra'
      end
    end

    it "returns 'Voltar ao processo de compra' otherwise" do
      component.stub(:trading? => false)

      expect(subject.edit_link).to eq 'Voltar ao processo de compra'
    end
  end

  context '#not_updatable_message' do
    let(:current_publication) { double(:current_publication, :publication_of_humanize => 'Edital')}
    let(:publications) { double(:publications, :current => current_publication) }
    let(:ratifications) { double(:ratifications) }

    before do
      I18n.backend.store_translations 'pt-BR', :licitation_process => {
          :messages => {
            :no_one_publication_with_valid_type => 'tipo invalido',
            :has_already_a_ratification => 'homologado',
            :has_already_a_publications => 'publicado'
        }
      }
    end

    it 'when is not updatable by invalid publication type' do
      component.stub(:updatable? => false)
      component.stub(:licitation_process_publications).and_return(publications)
      publications.stub(:current_updatable?).and_return(false)

      expect(subject.not_updatable_message).to eq 'tipo invalido'
    end

    it 'when is not updatable by invalid ratification' do
      component.stub(:updatable? => false)
      component.stub(:licitation_process_publications).and_return(publications)
      component.stub(:licitation_process_ratifications).and_return(ratifications)
      publications.stub(:current_updatable?).and_return(true)
      ratifications.stub(:any?).and_return(true)


      expect(subject.not_updatable_message).to eq 'homologado'
    end

    it 'when is not updatable by invalid publications' do
      component.stub(:updatable? => false)
      component.stub(:licitation_process_publications).and_return(publications)
      component.stub(:licitation_process_ratifications).and_return(ratifications)
      publications.stub(:current_updatable?).and_return(true)
      publications.stub(:any?).and_return(true)
      ratifications.stub(:any?).and_return(false)


      expect(subject.not_updatable_message).to eq 'publicado'
    end

    it 'when is updatable' do
      component.stub(:updatable? => true)

      expect(subject.not_updatable_message).to be_nil
    end
  end

  describe "#must_have_published_edital" do
    it "returns nil if edital have been published" do
      component.stub(:edital_published? => true)
      expect(subject.must_have_published_edital).to be_nil
    end

    it "returns disabled_message if edital have not been published" do
      I18n.backend.store_translations 'pt-BR', :licitation_process => {
        :messages => {
          :must_be_included_after_edital_publication => 'não pode'
        }
      }
      component.stub(:edital_published? => false)
      expect(subject.must_have_published_edital).to eq "não pode"
    end
  end

  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have code_and_year, modality, object_type and proposal_envelope_opening_date' do
      expect(described_class.header_attributes).to include :code_and_year
      expect(described_class.header_attributes).to include :modality
      expect(described_class.header_attributes).to include :object_type
      expect(described_class.header_attributes).to include :proposal_envelope_opening_date
      expect(described_class.header_attributes).to include :status
    end
  end

  describe '#all_licitation_process_classifications_groupped' do
    let(:bidder1) { double(:bidder1)}
    let(:bidder2) { double(:bidder2)}

    let :classification1 do
      double(:clalssification1, :bidder => bidder1, :classifiable_id => 2)
    end

    let :classification2 do
      double(:clalssification2, :bidder => bidder1, :classifiable_id => 1)
    end

    let :classification3 do
      double(:clalssification3, :bidder => bidder2, :classifiable_id => 1)
    end

    let :classification4 do
      double(:clalssification4, :bidder => bidder2, :classifiable_id => 2)
    end

    it 'should group all classifications by bidder and order classifications by items' do
      component.should_receive(:all_licitation_process_classifications).
                and_return([classification1, classification2, classification3, classification4])

      expect(subject.all_licitation_process_classifications_groupped).to eq bidder1 => [classification2, classification1], bidder2 => [classification3, classification4]
    end
  end

  describe '#disable_budget_allocations?' do
    it 'should be false when have no purchase_solicitation and item_group' do
      component.stub(:purchase_solicitation => nil)
      component.stub(:purchase_solicitation_item_group => nil)

      expect(subject.disable_budget_allocations?).to be_false
    end

    it 'should be true when have purchase_solicitation' do
      component.stub(:purchase_solicitation => 'purchase_solicitation')
      component.stub(:purchase_solicitation_item_group => nil)

      expect(subject.disable_budget_allocations?).to be_true
    end

    it 'should be true when have item_group' do
      component.stub(:purchase_solicitation => nil)
      component.stub(:purchase_solicitation_item_group => 'item_group')

      expect(subject.disable_budget_allocations?).to be_true
    end

    it 'should be true when have item_group and purchase_solicitation' do
      component.stub(:purchase_solicitation => 'purchase_solicitation')
      component.stub(:purchase_solicitation_item_group => 'item_group')

      expect(subject.disable_budget_allocations?).to be_true
    end
  end

  describe "#code_and_year" do
    before { component.stub(:process => 1, :year => 2012) }

    it "should return code/year" do
      expect(subject.code_and_year).to eq "1/2012"
    end
  end

   describe '#judgment_forms_available' do
    let(:judgment_form) { double(:judgment_form, :to_s => 'judgment_form') }
    let(:judgment_form_repository) { double(:judgment_form_repository) }

    context 'when there is a judgment_form selected' do
      before do
        component.stub(:judgment_form => judgment_form)
      end

      context 'when judgment_form selected is disabled' do
        before do
          judgment_form.stub(:enabled => false)
        end

        it 'should return all available and the selected' do
          judgment_form_repository.stub(:enabled => ['available1', 'available2'])

          expect(subject.judgment_forms_available(judgment_form_repository)).to eq ['available1', 'available2', judgment_form]
        end
      end

      context 'when judgment_form selected is enabled' do
        before do
          judgment_form.stub(:enabled => true)
        end

        it 'should return all available' do
          judgment_form_repository.stub(:enabled => ['available1', 'available2', judgment_form])

          expect(subject.judgment_forms_available(judgment_form_repository)).to eq ['available1', 'available2', judgment_form]
        end
      end

      context 'when there is no judgment_form' do
        it 'should return all available' do
          judgment_form_repository.stub(:enabled => ['available1', 'available2', judgment_form])

          expect(subject.judgment_forms_available(judgment_form_repository)).to eq ['available1', 'available2', judgment_form]
        end
      end
    end
  end

  describe '#subtitle' do
    it 'should returns the subtitle based at code and year' do
      subject.stub(:code_and_year => '1/2013')

      expect(subject.subtitle).to eq '1/2013'
    end
  end

  describe "#budget_allocations" do
    let(:budget1) { double(:budget_allocation, :budget_allocation => "Estrutura Orçamentária 1") }
    let(:budget2) { double(:budget_allocation, :budget_allocation => "Estrutura Orçamentária 2") }

    it 'should return budget_allocations' do
      budgets = [budget1, budget2]

      component.stub(:budget_allocations).and_return(budgets)
      expect(subject.budget_allocations).to eql "#{budget1}, #{budget2}"
    end
  end

  describe "#disabled_envelope_message" do
    before do
      I18n.backend.store_translations 'pt-BR', :licitation_process => {
        :messages => {
          :disabled_envelope_message => 'deve ter uma publição de edital',
        }
      }
    end

    it "returns a message when there isn't a publication date" do
      component.stub(:last_publication_date).and_return false

      expect(subject.disabled_envelope_message).to eq "deve ter uma publição de edital"
    end

    it "returns null when there is a publication date" do
      component.stub(:last_publication_date).and_return true

      expect(subject.disabled_envelope_message).to be_nil
    end
  end

  describe "#type_of_calculation" do
    before do
      component.stub(:judgment_form).and_return(judgment_form)
    end

    context "when lowest_price? and judgment_form.item? is true" do
      before do
        judgment_form.stub(:item?).and_return(true)
      end

      it { expect(subject.type_of_calculation).to eq 'lowest_price_by_item' }
    end

    context "when lowest_price? and judgment_form.global? is true" do
      before do
        judgment_form.stub(:global?).and_return(true)
      end

      it { expect(subject.type_of_calculation).to eq 'lowest_global_price' }
    end

    context "when lowest_price? and judgment_form.lot? is true" do
      before do
        judgment_form.stub(:lot?).and_return(true)
      end

      it { expect(subject.type_of_calculation).to eq 'lowest_price_by_lot' }
    end
  end
end
