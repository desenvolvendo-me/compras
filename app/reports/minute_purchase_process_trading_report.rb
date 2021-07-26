class MinutePurchaseProcessTradingReport < Report
  attr_accessor :licitation_process_id

  def licitation_process
    records.first
  end

  def issuance_date
    return if licitation_process.judgment_commission_advice_issuance_date.nil?

    I18n.l licitation_process.judgment_commission_advice_issuance_date
  end

  def proposal_envelope_opening_date
    return if licitation_process.proposal_envelope_opening_date.nil?

    I18n.l licitation_process.proposal_envelope_opening_date
  end

  def proposal_envelope_opening_time
    return if licitation_process.proposal_envelope_opening_time.nil?

    I18n.l licitation_process.proposal_envelope_opening_time, format: :hour
  end

  def judgment_commission_advice
    licitation_process.judgment_commission_advice
  end

  def licitation_commission
    return if judgment_commission_advice.nil?
    judgment_commission_advice.licitation_commission
  end

  def licitation_commission_members
    return if licitation_commission.nil?
    licitation_commission.licitation_commission_members.map(&:individual).join(', ').upcase
  end

  def member
    return if licitation_commission.nil?

    licitation_commission.licitation_commission_members.first
  end

  def representative_creditor(creditor)
    if creditor.company?
      creditor.representatives.first
    else
      creditor.person
    end
  end

  def bids
    return licitation_process.trading_item_bids.nil? ? [] : licitation_process.trading_item_bids
  end

  def auctioneer
    return if licitation_commission.auctioneer.empty?
    licitation_commission.auctioneer.first.individual.to_s.upcase
  end

  def creditor_winner(item)
    TradingItemWinner.new(item).creditor
  end

  def amount_winner(item)
    TradingItemWinner.new(item).amount
  end

  def ratifications_items
    licitation_process.ratifications_items.by_ratificated
  end

  private

  def normalize_attributes
    { :licitation_process => licitation_process_id }
  end

  def ratification_creditor_ids
    licitation_process.licitation_process_ratifications.map(&:creditor_id)
  end

  def bids_creditor_ids(creditor_ids)
    licitation_process.trading_item_bids.creditor_ids creditor_ids
  end
end
