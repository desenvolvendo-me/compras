require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/modality'
require 'app/business/purchase_process_proposal_envelope_opening_date_calculator'

describe PurchaseProcessProposalEnvelopeOpeningDateCalculator do
  let(:publication_date) { Date.new(2013, 6, 1) }
  let(:last_publication_edital) { double(:last_publication_edital, publication_date: publication_date) }
  let(:purchase_process) { double(:purchase_process, published_editals: [last_publication_edital]) }
  let(:date_calculator) { double(:date_calculator) }

  describe '#calculate' do
    subject do
      described_class.new(purchase_process, date_calculator: date_calculator)
    end

    context 'when edital is published' do
      before do
        purchase_process.stub(edital_published?: true)
      end

      context 'when modality is competition' do
        before do
          purchase_process.stub(modality: Modality::COMPETITION)
        end

        it 'should calculalte 45 calendar days' do
          date_calculator.should_receive(:calculate).with(publication_date, 45, :calendar).and_return('date')

          expect(subject.calculate).to eq 'date'
        end
      end

      context 'when modality is concurrence' do
        before do
          purchase_process.stub(modality: Modality::CONCURRENCE)
        end

        context 'when execution_type is not integral' do
          before do
            purchase_process.stub(integral?: false)
          end

          it 'should calculalte 30 calendar days' do
            date_calculator.should_receive(:calculate).with(publication_date, 30, :calendar).and_return('date')

            expect(subject.calculate).to eq 'date'
          end
        end

        context 'when execution_type is integral' do
          before do
            purchase_process.stub(integral?: true)
          end

          context 'when judgment_form is not best_technique neither technical_and_price' do
            before do
              purchase_process.stub(
                judgment_form_best_technique?: false,
                judgment_form_technical_and_price?: false
              )
            end

            it 'should calculalte 30 calendar days' do
              date_calculator.should_receive(:calculate).with(publication_date, 30, :calendar).and_return('date')

              expect(subject.calculate).to eq 'date'
            end
          end

          context 'when judgment_form is best_technique' do
            before do
              purchase_process.stub(
                judgment_form_best_technique?: true,
                judgment_form_technical_and_price?: false
              )
            end

            it 'should calculalte 45 calendar days' do
              date_calculator.should_receive(:calculate).with(publication_date, 45, :calendar).and_return('date')

              expect(subject.calculate).to eq 'date'
            end
          end

          context 'when judgment_form is technical_and_price' do
            before do
              purchase_process.stub(
                judgment_form_best_technique?: false,
                judgment_form_technical_and_price?: true
              )
            end

            it 'should calculalte 45 calendar days' do
              date_calculator.should_receive(:calculate).with(publication_date, 45, :calendar).and_return('date')

              expect(subject.calculate).to eq 'date'
            end
          end
        end
      end

      context 'when modality is taken_price' do
        before do
          purchase_process.stub(modality: Modality::TAKEN_PRICE)
        end

        context 'when judgment_form is not best_technique neither technical_and_price' do
          before do
            purchase_process.stub(
              judgment_form_best_technique?: false,
              judgment_form_technical_and_price?: false
            )
          end

          it 'should calculalte 15 calendar days' do
            date_calculator.should_receive(:calculate).with(publication_date, 15, :calendar).and_return('date')

            expect(subject.calculate).to eq 'date'
          end
        end

        context 'when judgment_form is best_technique' do
          before do
            purchase_process.stub(
              judgment_form_best_technique?: true,
              judgment_form_technical_and_price?: false
            )
          end

          it 'should calculalte 30 calendar days' do
            date_calculator.should_receive(:calculate).with(publication_date, 30, :calendar).and_return('date')

            expect(subject.calculate).to eq 'date'
          end
        end

        context 'when judgment_form is technical_and_price' do
          before do
            purchase_process.stub(
              judgment_form_best_technique?: false,
              judgment_form_technical_and_price?: true
            )
          end

          it 'should calculalte 30 calendar days' do
            date_calculator.should_receive(:calculate).with(publication_date, 30, :calendar).and_return('date')

            expect(subject.calculate).to eq 'date'
          end
        end
      end

      context 'when modality is auction' do
        before do
          purchase_process.stub(modality: Modality::AUCTION)
        end

        it 'should calculalte 15 calendar days' do
          date_calculator.should_receive(:calculate).with(publication_date, 15, :calendar).and_return('date')

          expect(subject.calculate).to eq 'date'
        end
      end

      context 'when modality is trading' do
        before do
          purchase_process.stub(modality: Modality::TRADING)
        end

        it 'should calculalte 8 working days' do
          date_calculator.should_receive(:calculate).with(publication_date, 8, :working).and_return('date')

          expect(subject.calculate).to eq 'date'
        end
      end

      context 'when modality is invitation' do
        before do
          purchase_process.stub(modality: Modality::INVITATION)
        end

        it 'should calculalte 5 working days' do
          date_calculator.should_receive(:calculate).with(publication_date, 5, :working).and_return('date')

          expect(subject.calculate).to eq 'date'
        end
      end

      context 'when modality is unknown' do
        before do
          purchase_process.stub(modality: nil)
        end

        it 'should return nil' do
          date_calculator.should_not_receive(:calculate)

          expect(subject.calculate).to be_nil
        end
      end
    end

    context 'when edital is not published' do
      before do
        purchase_process.stub(edital_published?: false)
      end

      it 'should return nil' do
        date_calculator.should_not_receive(:calculate)

        expect(subject.calculate).to be_nil
      end
    end
  end
end
