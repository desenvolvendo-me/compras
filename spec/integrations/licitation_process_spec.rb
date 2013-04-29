# encoding: UTF-8
require 'spec_helper'

describe LicitationProcess do
  it 'auto increment process by year' do
    licitation_2012 = LicitationProcess.make!(:processo_licitatorio_computador, :year => 2012, :process => nil)
    expect(licitation_2012.process).to eq 1

    licitation_2013 = LicitationProcess.make!(:processo_licitatorio_computador, :year => 2013, :process => nil, )
    expect(licitation_2013.process).to eq 1

    licitation_2013_2 = LicitationProcess.make!(:processo_licitatorio_computador, :year => 2013, :process => nil, :caution_value => 1.99)
    expect(licitation_2013_2.process).to eq 2
  end

  it 'auto increment modality_number by year and modality' do
    licitation_2012 = LicitationProcess.make!(:processo_licitatorio_computador, :year => 2012, :process => nil)
    expect(licitation_2012.modality_number).to eq 1

    licitation_2013 = LicitationProcess.make!(:processo_licitatorio_computador, :year => 2013, :process => nil)
    expect(licitation_2013.modality_number).to eq 1

    licitation_2013_2 = LicitationProcess.make!(:processo_licitatorio_computador, :year => 2013, :process => nil, :caution_value => 1.99)
    expect(licitation_2013_2.modality_number).to eq 2

    licitation_2013_3 = LicitationProcess.make!(:processo_licitatorio_computador, :year => 2013, :process => nil, :modality => Modality::COMPETITION)
    expect(licitation_2013_3.modality_number).to eq 1

    licitation_2013_4 = LicitationProcess.make!(:processo_licitatorio_computador, :year => 2013, :process => nil, :modality => Modality::COMPETITION, :caution_value => 1.99)
    expect(licitation_2013_4.modality_number).to eq 2
  end

  describe "#validate_proposal_envelope_opening_date" do
    let(:publication) { LicitationProcessPublication.make(:publicacao, :publication_date => Date.current) }

    context "competition modality validation" do
      it "should be 45 calendar days greater than last publication date" do
        licitation = LicitationProcess.make!(:processo_licitatorio_concurso, :publications => [publication])
        licitation.proposal_envelope_opening_date = Date.current + 44.days

        expect(licitation).to_not be_valid
        expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 45.days)}. Refente a 45 dias maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

        licitation.proposal_envelope_opening_date = Date.current + 45.days
        expect(licitation).to be_valid
      end
    end

    context "concurrence modality validation" do
      let(:licitation) do
        LicitationProcess.make!(:processo_licitatorio_concorrencia, :publications => [publication])
      end

      context "integral execution type" do
        it "should be 45 calendar days greater than last publication date when best technique or technical and price" do
          licitation.proposal_envelope_opening_date = Date.current + 44.days

          licitation.judgment_form.licitation_kind = LicitationKind::BEST_TECHNIQUE
          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 45.days)}. Refente a 45 dias maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

          licitation.judgment_form.licitation_kind = LicitationKind::TECHNICAL_AND_PRICE
          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 45.days)}. Refente a 45 dias maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

          licitation.proposal_envelope_opening_date = Date.current + 45.days
          expect(licitation).to be_valid
        end
      end

      context "execution type different from integral" do
        it "should be 30 calendar days greater than last publication date" do
          licitation.execution_type = ExecutionType::TASK
          licitation.proposal_envelope_opening_date = Date.current + 29.days
          licitation.judgment_form.licitation_kind = LicitationKind::BEST_TECHNIQUE

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 30.days)}. Refente a 30 dias maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

          licitation.judgment_form.licitation_kind = LicitationKind::TECHNICAL_AND_PRICE

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 30.days)}. Refente a 30 dias maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

          licitation.execution_type = ExecutionType::INTEGRAL
          licitation.judgment_form.licitation_kind = LicitationKind::BEST_AUCTION_OR_OFFER

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 30.days)}. Refente a 30 dias maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

          licitation.execution_type = ExecutionType::TASK

          licitation.proposal_envelope_opening_date = Date.current + 30.days
          expect(licitation).to be_valid
        end
      end
    end

    context "taken price modality validation" do
      let(:licitation)  { LicitationProcess.make!(:processo_licitatorio_tomada_preco, :publications => [publication]) }

      context "licitation kind is best technique or technical and price" do
        it "should be 30 calendar days greater than last publication date" do
          licitation.proposal_envelope_opening_date = Date.current + 29.days
          licitation.judgment_form.licitation_kind = LicitationKind::BEST_TECHNIQUE

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 30.days)}. Refente a 30 dias maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

          licitation.judgment_form.licitation_kind = LicitationKind::TECHNICAL_AND_PRICE

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 30.days)}. Refente a 30 dias maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

          licitation.proposal_envelope_opening_date = Date.current + 30.days
          expect(licitation).to be_valid
        end
      end

      context "execution type different from integral" do
        it "should be 15 calendar days greater than last publication date" do
          licitation.judgment_form.licitation_kind = LicitationKind::BEST_AUCTION_OR_OFFER
          licitation.save
          licitation.proposal_envelope_opening_date = Date.current + 14.days

          expect(licitation).to_not be_valid
          expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 15.days)}. Refente a 15 dias maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

          licitation.proposal_envelope_opening_date = Date.current + 15.days
          expect(licitation).to be_valid
        end
      end
    end

    context "auction modality validation" do
      it "should be 15 calendar days greater than last publication date" do
        licitation = LicitationProcess.make!(:processo_licitatorio_leilao, :publications => [publication])
        licitation.proposal_envelope_opening_date = Date.current + 14.days

        expect(licitation).to_not be_valid
        expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 15.days)}. Refente a 15 dias maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

        licitation.proposal_envelope_opening_date = Date.current + 15.days
        expect(licitation).to be_valid
      end
    end

    context "trading modality validation" do
      it "should be 8 working days greater than last publication date" do
        licitation = LicitationProcess.make!(:processo_licitatorio, :publications => [publication],
                                             :modality => Modality::TRADING, :execution_type => ExecutionType::INTEGRAL)
        licitation.proposal_envelope_opening_date = Date.current + 5.days

        expect(licitation).to_not be_valid
        expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 8.days)}. Refente a 8 dias úteis maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

        licitation.proposal_envelope_opening_date = Date.current + 15.days
        expect(licitation).to be_valid
      end
    end

    context "invitation modality validation" do
      it "should be 5 working days greater than last publication date" do
        licitation = LicitationProcess.make!(:processo_licitatorio, :publications => [publication],
                                             :modality => Modality::INVITATION, :execution_type => ExecutionType::INTEGRAL)
        licitation.proposal_envelope_opening_date = Date.current + 4.days

        expect(licitation).to_not be_valid
        expect(licitation.errors[:proposal_envelope_opening_date]).to include "deve ser a partir de #{I18n.l(Date.current + 5.days)}. Refente a 5 dias úteis maior que a data da publicação mais recente (#{I18n.l(Date.current)})"

        licitation.proposal_envelope_opening_date = Date.current + 10.days
        expect(licitation).to be_valid
      end
    end
  end
end
