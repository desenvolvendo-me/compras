# encoding: utf-8
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

  describe '#unit_price_of_proposal_by_item' do
    let(:item) { double(:item) }

    context 'without creditor_proposal_by_item' do
      before do
        component.should_receive(:creditor_proposal_by_item).with(item).and_return(nil)
      end

      it 'should return "-"' do
        expect(subject.unit_price_of_proposal_by_item(item)).to eq '-'
      end
    end

    context 'with creditor_proposal_by_item' do
      let(:proposal) { double(:proposal, unit_price: 1223.45) }

      before do
        component.should_receive(:creditor_proposal_by_item).with(item).and_return(proposal)
      end

      it 'should return the unit_price with precision' do
        component.should_receive(:creditor_proposal_by_item).with(item).and_return(proposal)

        expect(subject.unit_price_of_proposal_by_item(item)).to eq '1.223,45'
      end
    end
  end

  describe '#selected?' do
    before do
      I18n.backend.store_translations 'pt-BR', true: 'Sim'
      I18n.backend.store_translations 'pt-BR', false: 'Não'
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
          expect(subject.selected?).to eq 'Sim'
        end
      end

      context 'when is an individual' do
        before do
          component.stub(creditor_individual?: true)
        end

        it 'should return Sim' do
          expect(subject.selected?).to eq 'Sim'
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
          expect(subject.selected?).to eq 'Não'
        end
      end

      context 'when is an individual' do
        before do
          component.stub(creditor_individual?: true)
        end

        it 'should return Sim' do
          expect(subject.selected?).to eq 'Sim'
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
end
