class MinutePurchaseProcessReport < ActiveRelatus::Base
  attr_accessor :licitation_process_id

  def licitation_process
    records.first
  end

  def issuance_date
    return if licitation_process.judgment_commission_advice_issuance_date.nil?

    I18n.l licitation_process.judgment_commission_advice_issuance_date
  end

  def licitation_commission
    return if judgment_commission_advice.nil?
    judgment_commission_advice.licitation_commission
  end

  def proposal_envelope_opening_date
    return if licitation_process.proposal_envelope_opening_date.nil?

    I18n.l licitation_process.proposal_envelope_opening_date
  end

  def proposal_envelope_opening_time
    return if licitation_process.proposal_envelope_opening_time.nil?

    I18n.l licitation_process.proposal_envelope_opening_time, format: :hour
  end

  def licitation_commission_members
    return if licitation_commission.licitation_commission_members.empty?

    licitation_commission.licitation_commission_members.map(&:individual).join(', ').upcase
  end

  def member
    return if licitation_commission.licitation_commission_members.empty?

    licitation_commission.licitation_commission_members.last
  end

  def president
    return if licitation_commission.nil?
    licitation_commission.president.to_s.upcase
  end

  def proposals
    if licitation_process.direct_purchase?
      licitation_process.items
    else
      licitation_process.creditor_proposals
    end
  end

  def judgment_commission_advice
    licitation_process.judgment_commission_advice
  end

  def representative_creditor(creditor)
    if creditor.company?
      creditor.representatives.first
    else
      creditor
    end
  end

  def representative
    return if creditor_winner.empty?
    creditor_winner.first.creditor
  end

  def bidders_enabled
    licitation_process.bidders.where { enabled }
  end

  def creditor_winner
    if licitation_process.direct_purchase?
      licitation_process.items
    else
      licitation_process.creditor_proposals.winning_proposals
    end
  end

  def ratifications_items
    licitation_process.ratifications_items.by_ratificated
  end

  protected

  def normalize_attributes
    { :licitation_process => licitation_process_id }
  end
end

