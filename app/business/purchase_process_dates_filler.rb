class PurchaseProcessDatesFiller
  def initialize(purchase_process, options = {})
    @purchase_process = purchase_process
    @proposal_envelope_opening_date_calculator = options.fetch(:proposal_envelope_opening_date_calculator) { PurchaseProcessProposalEnvelopeOpeningDateCalculator }
  end

  def self.fill(*args)
    new(*args).fill
  end

  def fill
    return unless calculated_date

    fill_in :proposal_envelope_opening_date
    fill_in :authorization_envelope_opening_date
    fill_in :closing_of_accreditation_date
    fill_in :stage_of_bids_date
  end

  private

  attr_reader :purchase_process, :proposal_envelope_opening_date_calculator

  def calculated_date
    @calculated_date ||= proposal_envelope_opening_date_calculator.calculate(purchase_process)
  end

  def fill_in(attribute)
    return unless purchase_process.send(attribute).blank?

    purchase_process.update_column attribute, calculated_date
  end
end
