require 'decorator_helper'
require 'app/decorators/purchase_process_accreditation_creditor_decorator'

describe PurchaseProcessAccreditationCreditorDecorator do
  describe '#creditor_representative' do
    context 'without creditor_representative' do
      before do
        component.stub(:creditor_representative => nil)
      end

      it 'should return "Não possui representante"' do
        expect(subject.creditor_representative).to eq 'Não possui representante'
      end
    end

    context 'with creditor_representative' do
      before do
        component.stub(:creditor_representative => 'creditor')
      end

      it 'should return creditor_representative' do
        expect(subject.creditor_representative).to eq 'creditor'
      end
    end
  end

  describe '#unit_price_of_proposal' do
    let(:item) { double(:item) }

    context 'when judgment_form by item' do
      before do
        component.stub judgment_form_item?: true
      end

      context 'without creditor_proposal_by_item' do
        it 'should return "-"' do
          component.should_receive(:creditor_proposal_by_item).with(1, item).and_return(nil)

          expect(subject.unit_price_of_proposal(1, item)).to eq '-'
        end
      end

      context 'with creditor_proposal_by_item' do
        let(:proposal) { double(:proposal, unit_price: 1223.45) }

        it 'should return the unit_price with precision' do
          component.should_receive(:creditor_proposal_by_item).twice.with(1, item).and_return(proposal)

          expect(subject.unit_price_of_proposal(1, item)).to eq '1.223,45'
        end
      end
    end

    context 'when judgment_form not by item' do
      before do
        component.stub judgment_form_item?: false
      end

      context 'without creditor_proposal_by_lot' do
        before do
          component.should_receive(:creditor_proposal_by_lot).with(5, 1).and_return(nil)
        end

        it 'should return "-"' do
          expect(subject.unit_price_of_proposal(5, 1)).to eq '-'
        end
      end

      context 'with creditor_proposal_by_lot' do
        let(:proposal) { double(:proposal, unit_price: 1223.45) }

        it 'should return the unit_price with precision' do
          component.should_receive(:creditor_proposal_by_lot).twice.with(5, 1).and_return(proposal)

          expect(subject.unit_price_of_proposal(5, 1)).to eq '1.223,45'
        end
      end
    end
  end

  describe '#selected?' do
    let(:item_or_lot) { double(:item_or_lot) }
    let(:proposal) { double(:proposal) }

    before do
      I18n.backend.store_translations 'pt-BR', true: 'Sim'
      I18n.backend.store_translations 'pt-BR', false: 'Não'
    end

    context 'when has qualified proposal' do
      before do
        subject.stub(proposal: proposal)
        proposal.stub(qualified?: true)
      end

      context 'when has power of attorney' do
        before do
          component.stub(has_power_of_attorney?: true)
        end

        context 'when is not an individual' do
          before do
            component.stub(creditor_individual?: false)
          end

          it 'should return Sim' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Sim'
          end
        end

        context 'when is an individual' do
          before do
            component.stub(creditor_individual?: true)
          end

          it 'should return Sim' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Sim'
          end
        end
      end

      context 'when has no power of attorney' do
        before do
          component.stub(has_power_of_attorney?: false)
        end

        context 'when is not an individual' do
          before do
            component.stub(creditor_individual?: false)
          end

          it 'should return Não' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Não'
          end
        end

        context 'when is an individual' do
          before do
            component.stub(creditor_individual?: true)
          end

          it 'should return Sim' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Sim'
          end
        end
      end
    end

    context 'when has a not qualified proposal' do
      before do
        subject.stub(proposal: proposal)
        proposal.stub(qualified?: false)
      end

      context 'when has power of attorney' do
        before do
          component.stub(has_power_of_attorney?: true)
        end

        context 'when is not an individual' do
          before do
            component.stub(creditor_individual?: false)
          end

          it 'should return Não' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Não'
          end
        end

        context 'when is an individual' do
          before do
            component.stub(creditor_individual?: true)
          end

          it 'should return Não' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Não'
          end
        end
      end

      context 'when has no power of attorney' do
        before do
          component.stub(has_power_of_attorney?: false)
        end

        context 'when is not an individual' do
          before do
            component.stub(creditor_individual?: false)
          end

          it 'should return Não' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Não'
          end
        end

        context 'when is an individual' do
          before do
            component.stub(creditor_individual?: true)
          end

          it 'should return Não' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Não'
          end
        end
      end
    end

    context 'when has not a proposal' do
      before do
        subject.stub(proposal: nil)
      end

      context 'when has power of attorney' do
        before do
          component.stub(has_power_of_attorney?: true)
        end

        context 'when is not an individual' do
          before do
            component.stub(creditor_individual?: false)
          end

          it 'should return Não' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Não'
          end
        end

        context 'when is an individual' do
          before do
            component.stub(creditor_individual?: true)
          end

          it 'should return Não' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Não'
          end
        end
      end

      context 'when has no power of attorney' do
        before do
          component.stub(has_power_of_attorney?: false)
        end

        context 'when is not an individual' do
          before do
            component.stub(creditor_individual?: false)
          end

          it 'should return Não' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Não'
          end
        end

        context 'when is an individual' do
          before do
            component.stub(creditor_individual?: true)
          end

          it 'should return Não' do
            expect(subject.selected?(5, item_or_lot)).to eq 'Não'
          end
        end
      end
    end
  end

  describe '#personable_type' do
    it "should return the component's creditor_personable_type_humanize" do
      component.should_receive(:creditor_personable_type_humanize).and_return('Pessoa física')

      expect(subject.personable_type).to eq 'Pessoa física'
    end
  end

  describe '#has_power_of_attorney_text' do
    before do
      I18n.backend.store_translations 'pt-BR', true: 'Sim'
      I18n.backend.store_translations 'pt-BR', false: 'Não'
    end

    context 'when has power of attorney' do
      before do
        component.stub(has_power_of_attorney?: true)
      end

      it 'should return Sim' do
        expect(subject.has_power_of_attorney_text).to eq 'Sim'
      end
    end

    context 'when has no power of attorney' do
      before do
        component.stub(has_power_of_attorney?: false)
      end

      it 'should return Não' do
        expect(subject.has_power_of_attorney_text).to eq 'Não'
      end
    end
  end

  describe '#kind_text' do
    it "should return the component's kind_humanize" do
      component.should_receive(:kind_humanize).and_return('Legal')

      expect(subject.kind_text).to eq 'Legal'
    end
  end

  describe '#not_selected_class' do
    context 'when allowed' do
      before do
        subject.stub(allowed?: true)
      end

      it 'should return nil' do
        expect(subject.not_selected_class(8, 5)).to be_nil
      end
    end

    context 'when not allowed' do
      before do
        subject.stub(allowed?: false)
      end

      it "should return 'not_selected'" do
        expect(subject.not_selected_class(8, 5)).to eq 'not_selected'
      end
    end
  end
end
