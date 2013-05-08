class PurchaseProcessEnvelopeOpeningDate
  def initialize(purchase_process)
    @purchase_process = purchase_process
    @proposal_envelope_opening_date = purchase_process.proposal_envelope_opening_date
    @publication_date = purchase_process.last_publication_date
    @modality = purchase_process.modality
    @execution_type = purchase_process.execution_type
    @judgment_form = purchase_process.judgment_form
  end

  def valid?
    run_validation
  end

  private

  attr_reader :purchase_process, :proposal_envelope_opening_date, :publication_date, :modality,
              :execution_type, :judgment_form

  def run_validation
    return true unless respond_to?("#{@modality}_validation", true)
    send("#{@modality}_validation") == false ? false : true
  end

  def over_days_error(days, context)
    values  = { :limit => I18n.l(publication_date + days.days), :days => days, :publication => I18n.l(publication_date) }
    message = I18n.t("licitation_process.messages.proposal_envelope_opening_date_greater_than_#{context}_days", values)
    purchase_process.errors.add :proposal_envelope_opening_date, message
    return false
  end

  def valid_proposal_envelope_opening_date?(days, context)
    count = DaysCounter.new(publication_date, proposal_envelope_opening_date).count(context)
    over_days_error(days, context) if count <= days
  end

  def competition_validation
    valid_proposal_envelope_opening_date?(45, :calendar)
  end

  def concurrence_validation
    if purchase_process.integral? && (judgment_form.best_technique? || judgment_form.technical_and_price?)
      valid_proposal_envelope_opening_date?(45, :calendar)
    else
      valid_proposal_envelope_opening_date?(30, :calendar)
    end
  end

  def taken_price_validation
    if judgment_form.best_technique? || judgment_form.technical_and_price?
      valid_proposal_envelope_opening_date?(30, :calendar)
    else
      valid_proposal_envelope_opening_date?(15, :calendar)
    end
  end

  def auction_validation
    valid_proposal_envelope_opening_date?(15, :calendar)
  end

  def trading_validation
    valid_proposal_envelope_opening_date?(8, :working)
  end

  def invitation_validation
    valid_proposal_envelope_opening_date?(5, :working)
  end
end