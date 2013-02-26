class LicitationProcessEnvelopeOpeningDate
  def initialize(licitation_process)
    @licitation_process = licitation_process
    @envelope_opening_date = licitation_process.envelope_opening_date
    @publication_date = licitation_process.last_publication_date
    @modality = licitation_process.administrative_process_modality
    @execution_type = licitation_process.execution_type
    @licitation_kind = licitation_process.judgment_form_licitation_kind
  end

  def valid?
    run_validation
  end

  private

  attr_reader :licitation_process, :envelope_opening_date, :publication_date, :modality,
              :execution_type, :licitation_kind

  def run_validation
    return true unless respond_to?("#{@modality}_validation", true)
    send("#{@modality}_validation") == false ? false : true
  end

  def over_days_error(days, context)
    values  = { :limit => I18n.l(publication_date + days.days), :days => days, :publication => I18n.l(publication_date) }
    message = I18n.t("licitation_process.messages.envelope_opening_date_greater_than_#{context}_days", values)
    licitation_process.errors.add :envelope_opening_date, message
    return false
  end

  def valid_envelope_opening_date?(days, context)
    count = DaysCounter.new(publication_date, envelope_opening_date).count(context)
    over_days_error(days, context) if count <= days
  end

  def competition_validation
    valid_envelope_opening_date?(45, :calendar)
  end

  def concurrence_validation
    if execution_type == "integral" && ["best_technique", "technical_and_price"].include?(licitation_kind)
      valid_envelope_opening_date?(45, :calendar)
    else
      valid_envelope_opening_date?(30, :calendar)
    end
  end

  def taken_price_validation
    if ["best_technique", "technical_and_price"].include? licitation_kind
      valid_envelope_opening_date?(30, :calendar)
    else
      valid_envelope_opening_date?(15, :calendar)
    end
  end

  def auction_validation
    valid_envelope_opening_date?(15, :calendar)
  end

  def trading_validation
    valid_envelope_opening_date?(8, :working)
  end

  def invitation_validation
    valid_envelope_opening_date?(5, :working)
  end
end
