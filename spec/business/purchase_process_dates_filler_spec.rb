require 'unit_helper'
require 'active_support/core_ext/date/calculations'
require 'app/business/purchase_process_dates_filler'

describe PurchaseProcessDatesFiller do
  let(:date_calculator) { double(:date_calculator) }
  let(:purchase_process) { double(:purchase_process) }

  describe '#fill' do
    subject do
      described_class.new(purchase_process, proposal_envelope_opening_date_calculator: date_calculator)
    end

    context 'when has no calculated_date' do
      it 'should do nothing' do
        date_calculator.should_receive(:calculate).with(purchase_process).and_return nil

        subject.should_not_receive(:fill_in)

        subject.fill
      end
    end

    context 'when has calculated_date' do
      before do
        date_calculator.should_receive(:calculate).with(purchase_process).and_return Date.current
      end

      context 'when dates are already filled' do
        before do
          purchase_process.stub(
            proposal_envelope_opening_date: Date.yesterday,
            authorization_envelope_opening_date: Date.yesterday,
            closing_of_accreditation_date: Date.yesterday,
            stage_of_bids_date: Date.yesterday
          )
        end

        it 'should not change dates' do
          purchase_process.should_not_receive(:update_column)

          subject.fill
        end
      end

      context 'when dates are not filled' do
        before do
          purchase_process.stub(
            proposal_envelope_opening_date: nil,
            authorization_envelope_opening_date: Date.yesterday,
            closing_of_accreditation_date: nil,
            stage_of_bids_date: Date.yesterday
          )
        end

        it 'should change dates not filled' do
          purchase_process.should_receive(:update_column).with(:proposal_envelope_opening_date, Date.current)
          purchase_process.should_receive(:update_column).with(:closing_of_accreditation_date, Date.current)

          subject.fill
        end
      end
    end
  end
end
