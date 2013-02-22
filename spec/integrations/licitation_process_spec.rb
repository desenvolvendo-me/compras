# encoding: UTF-8
require 'spec_helper'

describe LicitationProcess do
  it 'auto increment process by year' do
    licitation_2012 = LicitationProcess.make(:processo_licitatorio)
    licitation_2012.save!
    expect(licitation_2012.process).to eq 1

    licitation_2013 = LicitationProcess.make(:processo_licitatorio_computador)
    licitation_2013.save!
    expect(licitation_2013.process).to eq 1

    licitation_2013_2 = LicitationProcess.make(:processo_licitatorio_canetas)
    licitation_2013_2.save!
    expect(licitation_2013_2.process).to eq 2
  end

  describe "#validate_envelope_opening_date" do
    context "competition modality validation" do
      it "should be 45 calendar days greater than last publication date" do
        licitation = LicitationProcess.make(:processo_licitatorio_concurso)
        licitation.save
        licitation.licitation_process_publications.last.publication_date = Date.today
        licitation.envelope_opening_date = Date.today + 44.days

        expect(licitation).to_not be_valid
        expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 45 dias maior que a data da publicação mais recente"

        licitation.envelope_opening_date = Date.today + 45.days
        expect(licitation).to be_valid
      end
    end

    context "concurrence modality validation" do
      let(:licitation) { LicitationProcess.make(:processo_licitatorio_concorrencia) }

      context "integral execution type" do
        it "should be 45 calendar days greater than last publication date" do
          licitation.save
          licitation.licitation_process_publications.last.publication_date = Date.today
          licitation.envelope_opening_date = Date.today + 44.days

          licitation.judgment_form.licitation_kind = LicitationKind::BEST_TECHNIQUE
          expect(licitation).to_not be_valid
          expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 45 dias maior que a data da publicação mais recente"

          licitation.judgment_form.licitation_kind = LicitationKind::TECHNICAL_AND_PRICE
          expect(licitation).to_not be_valid
          expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 45 dias maior que a data da publicação mais recente"

          licitation.envelope_opening_date = Date.today + 45.days
          expect(licitation).to be_valid
        end
      end

      context "execution type different from integral" do
        it "should be 30 calendar days greater than last publication date" do
          licitation.save
          licitation.execution_type = ExecutionType::TASK
          licitation.licitation_process_publications.last.publication_date = Date.today
          licitation.envelope_opening_date = Date.today + 29.days

          licitation.judgment_form.licitation_kind = LicitationKind::BEST_TECHNIQUE
          expect(licitation).to_not be_valid
          expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 30 dias maior que a data da publicação mais recente"

          licitation.judgment_form.licitation_kind = LicitationKind::TECHNICAL_AND_PRICE
          expect(licitation).to_not be_valid
          expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 30 dias maior que a data da publicação mais recente"

          licitation.envelope_opening_date = Date.today + 30.days
          expect(licitation).to be_valid
        end
      end
    end

    context "taken price modality validation" do
      let(:licitation) { LicitationProcess.make(:processo_licitatorio_tomada_preco) }

      context "licitation kind is best technique or technical and price" do
        it "should be 30 calendar days greater than last publication date" do
          licitation.save
          licitation.licitation_process_publications.last.publication_date = Date.today
          licitation.envelope_opening_date = Date.today + 29.days

          licitation.judgment_form.licitation_kind = LicitationKind::BEST_TECHNIQUE
          expect(licitation).to_not be_valid
          expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 30 dias maior que a data da publicação mais recente"

          licitation.judgment_form.licitation_kind = LicitationKind::TECHNICAL_AND_PRICE
          expect(licitation).to_not be_valid
          expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 30 dias maior que a data da publicação mais recente"

          licitation.envelope_opening_date = Date.today + 30.days
          expect(licitation).to be_valid
        end
      end

      context "execution type different from integral" do
        it "should be 15 calendar days greater than last publication date" do
          licitation.judgment_form.licitation_kind = LicitationKind::BEST_AUCTION_OR_OFFER
          licitation.save
          licitation.licitation_process_publications.last.publication_date = Date.today
          licitation.envelope_opening_date = Date.today + 14.days

          expect(licitation).to_not be_valid
          expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 15 dias maior que a data da publicação mais recente"

          licitation.envelope_opening_date = Date.today + 15.days
          expect(licitation).to be_valid
        end
      end
    end

    context "auction modality validation" do
      it "should be 15 calendar days greater than last publication date" do
        administrative_process = AdministrativeProcess.make!(:maior_lance_por_itens)
        licitation = LicitationProcess.make(:processo_licitatorio_leilao, :administrative_process => administrative_process)
        licitation.save
        licitation.licitation_process_publications.last.publication_date = Date.today
        licitation.envelope_opening_date = Date.today + 14.days

        expect(licitation).to_not be_valid
        expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 15 dias maior que a data da publicação mais recente"

        licitation.envelope_opening_date = Date.today + 15.days
        expect(licitation).to be_valid
      end
    end

    context "trading modality validation" do
      it "should be 8 working days greater than last publication date" do
        licitation = LicitationProcess.make(:processo_licitatorio)
        licitation.administrative_process.modality = Modality::TRADING
        licitation.execution_type = ExecutionType::INTEGRAL
        licitation.save

        licitation.licitation_process_publications.last.publication_date = Date.today
        licitation.envelope_opening_date = Date.today + 5.days
        expect(licitation).to_not be_valid
        expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 8 dias úteis maior que a data da publicação mais recente"

        licitation.envelope_opening_date = Date.today + 15.days
        expect(licitation).to be_valid
      end
    end

    context "invitation modality validation" do
      it "should be 5 working days greater than last publication date" do
        licitation = LicitationProcess.make(:processo_licitatorio)
        licitation.administrative_process.modality = Modality::INVITATION
        licitation.execution_type = ExecutionType::INTEGRAL
        licitation.save

        licitation.licitation_process_publications.last.publication_date = Date.today
        licitation.envelope_opening_date = Date.today + 4.days
        expect(licitation).to_not be_valid
        expect(licitation.errors[:envelope_opening_date]).to include "Data de abertura do envelope precisa ser 5 dias úteis maior que a data da publicação mais recente"

        licitation.envelope_opening_date = Date.today + 8.days
        expect(licitation).to be_valid
      end
    end
  end
end
