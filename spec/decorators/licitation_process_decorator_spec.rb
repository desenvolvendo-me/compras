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

  context '#proposal_envelope_opening_date' do
    context 'when do not have proposal_envelope_opening_date' do
      before do
        component.stub(:proposal_envelope_opening_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.proposal_envelope_opening_date).to be_nil
      end
    end

    context 'when have proposal_envelope_opening_date' do
      before do
        component.stub(:proposal_envelope_opening_date).and_return(Date.new(2013,01,01))
      end

      it 'should localize proposal_envelope_opening_date' do
        expect(subject.proposal_envelope_opening_date).to eq '01/01/2013'
      end
    end
  end

  context '#budget_allocations_total_value' do
    context 'when do not have budget_allocations_total_value' do
      before do
        component.stub(:budget_allocations_total_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.budget_allocations_total_value).to be_nil
      end
    end

    context 'when have budget_allocations_total_value' do
      before do
        component.stub(:budget_allocations_total_value).and_return(10.50)
      end

      it 'should localize budget_allocations_total_value' do
        expect(subject.budget_allocations_total_value).to eq '10,50'
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

  describe "#must_be_published_on_edital" do
    it "returns nil if edital have been published" do
      component.stub(:edital_published? => true)
      expect(subject.must_be_published_on_edital).to be_nil
    end

    it "returns disabled_message if edital have not been published" do
      I18n.backend.store_translations 'pt-BR', :licitation_process => {
        :messages => {
          :disabled_envelope_message => 'não pode'
        }
      }
      component.stub(:edital_published? => false)
      expect(subject.must_be_published_on_edital).to eq "não pode"
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

  describe "#must_have_published_edital_or_direct_purchase" do
    it "returns nil if edital have been published or licitation_process is direct_purchase" do
      component.stub(:edital_published? => true)
      component.stub(:direct_purchase? => true)
      expect(subject.must_have_published_edital).to be_nil
    end

    it "returns disabled_message if edital have not been published or licitation process is licitation " do
      I18n.backend.store_translations 'pt-BR', :licitation_process => {
        :messages => {
          :must_be_included_after_edital_publication => 'não pode'
        }
      }
      component.stub(:edital_published? => false)
      component.stub(:direct_purchase? => false)
      expect(subject.must_have_published_edital).to eq "não pode"
    end

    it "returns nil if edital have been published or licitation_process is licitation " do
      component.stub(:edital_published? => true)
      component.stub(:direct_purchase? => false)
      expect(subject.must_have_published_edital).to eq nil
    end
  end

  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have code_and_year, modality, object_type and proposal_envelope_opening_date' do
      expect(described_class.header_attributes).to include :code_and_year
      expect(described_class.header_attributes).to include :modality_or_type_of_removal
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
    let(:budget1) { double(:purchase_process_budget_allocations, :budget_allocation => "Estrutura Orçamentária 1") }
    let(:budget2) { double(:purchase_process_budget_allocations, :budget_allocation => "Estrutura Orçamentária 2") }

    it 'should return budget_allocations' do
      budgets = [budget1, budget2]

      component.stub(:purchase_process_budget_allocations).and_return(budgets)
      expect(subject.purchase_process_budget_allocations).to eql budgets
    end
  end

  describe '#disabled_trading_message' do
    context 'there isnt any creditor proposal' do
      before do
        component.stub(creditor_proposals: [])

        I18n.backend.store_translations 'pt-BR', licitation_process: {
          messages: { disabled_trading_message: 'deve ter ao menos uma proposta' }
        }
      end

      it 'returns the disabled message' do
        expect(subject.disabled_trading_message).to eq 'deve ter ao menos uma proposta'
      end
    end

    context 'there are creditor proposals' do
      before { component.stub(creditor_proposals: [double(:creditor_proposals)]) }

      it { expect(subject.disabled_trading_message).to be_nil }
    end
  end

  describe "#disabled_envelope_message" do
    before do
      I18n.backend.store_translations 'pt-BR', :licitation_process => {
        :messages => {
          :disabled_envelope_message => 'deve ter uma publicação de edital',
        }
      }
    end

    it "returns a message when there isn't a publication date" do
      component.stub(:last_publication_date).and_return false

      expect(subject.disabled_envelope_message).to eq "deve ter uma publicação de edital"
    end

    it "returns null when there is a publication date" do
      component.stub(:last_publication_date).and_return true

      expect(subject.disabled_envelope_message).to be_nil
    end
  end

  describe '#must_have_trading' do
    let(:trading) { double('trading') }

    before do
      I18n.backend.store_translations 'pt-BR', licitation_process: {
        messages: {
          must_have_trading: 'deve ter lances'
        }
      }
    end

    context 'when trading is nil?' do
      before do
        component.stub(:trading).and_return nil
      end

      it 'return a message' do
        expect(subject.must_have_trading).to eq 'deve ter lances'
      end
    end

    context 'when trading is not nil' do
      before do
        component.stub(:trading).and_return trading
      end

      it 'return nil' do
        expect(subject.must_have_trading).to be_nil
      end
    end
  end

  describe '#proposals_total_price' do
    it 'returns the localized proposals total price' do
      creditor = double(:creditor)
      component.stub(:proposals_total_price).and_return 9.99

      expect(subject.proposals_total_price(creditor)).to eql '9,99'
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

  describe "#must_have_creditors_and_items" do
    it "returns nil if licitation process has creditors and items" do
      component.stub(:materials => [double], :creditors => [double])

      expect(subject.must_have_creditors_and_items).to be_nil
    end

    it "returns disabled_message if licitation process has not items or creditors" do
      I18n.backend.store_translations 'pt-BR', :licitation_process => {
        :messages => {
          :must_have_creditors_and_items => 'deve ter credores e itens'
        }
      }

      component.stub(:materials => [double], :creditors => [])
      expect(subject.must_have_creditors_and_items).to eq 'deve ter credores e itens'
    end
  end

  describe '#material_unique_class' do
    context 'when not direct_purchase' do
      before do
        component.stub(direct_purchase?: false)
      end

      it { expect(subject.material_unique_class).to eq 'unique' }
    end

    context 'when is a direct_purchase' do
      before do
        component.stub(direct_purchase?: true)
      end

      context 'when dispensation_justified_accreditation' do
        before do
          component.stub(type_of_removal_dispensation_justified_accreditation?: true)
        end

        it { expect(subject.material_unique_class).to eq '' }
      end

      context 'when unenforceability_accreditation' do
        before do
          component.stub(type_of_removal_dispensation_justified_accreditation?: false)
          component.stub(type_of_removal_unenforceability_accreditation?: true)
        end

        it { expect(subject.material_unique_class).to eq '' }
      end

      context 'when not dispensation_justified_accreditation neighter unenforceability_accreditation' do
        before do
          component.stub(type_of_removal_dispensation_justified_accreditation?: false)
          component.stub(type_of_removal_unenforceability_accreditation?: false)
        end

        it { expect(subject.material_unique_class).to eq 'unique' }
      end
    end
  end

  describe '#enabled_realignment_price?' do
    context 'when is a trading' do
      before do
        component.stub(trading?: true)
        component.stub(licitation?: true)
      end

      context 'when not allow negotiation' do
        let(:trading) { double(:trading) }

        before do
          component.stub(trading: trading)
          trading.stub(allow_negotiation?: false)
        end

        it { expect(subject.enabled_realignment_price?).to be_false }
      end

      context 'when allow negotiation' do
        let(:trading) { double(:trading) }

        before do
          component.stub(trading: trading)
          trading.stub(allow_negotiation?: true)
        end

        context 'when judgment_form is global' do
          before do
            component.stub(judgment_form_global?: true)
            component.stub(judgment_form_lot?: false)
          end

          it { expect(subject.enabled_realignment_price?).to be_true }
        end

        context 'when judgment_form is lot' do
          before do
            component.stub(judgment_form_global?: false)
            component.stub(judgment_form_lot?: true)
          end

          it { expect(subject.enabled_realignment_price?).to be_true }
        end

        context 'when judgment_form is not global neigher lot' do
          before do
            component.stub(judgment_form_global?: false)
            component.stub(judgment_form_lot?: false)
          end

          it { expect(subject.enabled_realignment_price?).to be_false }
        end
      end
    end

    context 'when is not a trading' do
      let(:bidder1) { double(:bidder1, creditor: 'creditor1') }
      let(:bidder2) { double(:bidder2, creditor: 'creditor2') }

      before do
        component.stub(bidders: [bidder1, bidder2])
        component.stub(trading?: false)
      end

      context 'when is a licitation' do
        before do
          component.stub(licitation?: true)
        end

        context 'all creditors have proposal' do
          context 'when judgment_form is global' do
            before do
              component.stub(judgment_form_global?: true)
              component.stub(judgment_form_lot?: false)
            end

            it 'should be true' do
              component.should_receive(:proposals_of_creditor).with('creditor1').and_return(['proposal1'])
              component.should_receive(:proposals_of_creditor).with('creditor2').and_return(['proposal2'])

              expect(subject.enabled_realignment_price?).to be_true
            end
          end

          context 'when judgment_form is lot' do
            before do
              component.stub(judgment_form_global?: false)
              component.stub(judgment_form_lot?: true)
            end

            it 'should be true' do
              component.should_receive(:proposals_of_creditor).with('creditor1').and_return(['proposal1'])
              component.should_receive(:proposals_of_creditor).with('creditor2').and_return(['proposal2'])

              expect(subject.enabled_realignment_price?).to be_true
            end
          end

          context 'when judgment_form is not global neigher lot' do
            before do
              component.stub(judgment_form_global?: false)
              component.stub(judgment_form_lot?: false)
            end

            it 'should be false' do
              component.should_receive(:proposals_of_creditor).with('creditor1').and_return(['proposal1'])
              component.should_receive(:proposals_of_creditor).with('creditor2').and_return(['proposal2'])

              expect(subject.enabled_realignment_price?).to be_false
            end
          end
        end

        context 'not all creditors have proposals' do
          it 'should be false' do
            component.should_receive(:proposals_of_creditor).with('creditor1').and_return([])

            expect(subject.enabled_realignment_price?).to be_false
          end
        end
      end

      context 'when not a licitation' do
        before do
          component.stub(licitation?: false)
        end

        context 'when judgment_form is global' do
          before do
            component.stub(judgment_form_global?: true)
            component.stub(judgment_form_lot?: false)
          end

          it { expect(subject.enabled_realignment_price?).to be_false }
        end

        context 'when judgment_form is lot' do
          before do
            component.stub(judgment_form_global?: false)
            component.stub(judgment_form_lot?: true)
          end

          it { expect(subject.enabled_realignment_price?).to be_false }
        end

        context 'when judgment_form is not global neigher lot' do
          before do
            component.stub(judgment_form_global?: false)
            component.stub(judgment_form_lot?: false)
          end

          it { expect(subject.enabled_realignment_price?).to be_false }
        end
      end
    end
  end
end
