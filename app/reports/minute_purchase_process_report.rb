class MinutePurchaseProcessReport < Report
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
    
    return if !licitation_commission.nil? && licitation_commission.licitation_commission_members.empty?

    licitation_commission.licitation_commission_members.map(&:individual).join(', ').upcase if licitation_commission
  end

  def member
    return if !licitation_commission.nil? && licitation_commission.licitation_commission_members.empty?

    licitation_commission.licitation_commission_members.last if licitation_commission
  end

  def president
    return if licitation_commission.nil?
    licitation_commission.president.to_s.upcase
  end

  def proposals
    if licitation_process.simplified_processes?
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
    if licitation_process.simplified_processes?
      licitation_process.items
    else
      licitation_process.creditor_proposals.winning_proposals
    end
  end

  #retorna os fornecedores vencedores e o valor total das propostas
  def creditor_ratified
    ratified_items = licitation_process.ratifications_items.includes(:licitation_process_ratification)
    creditors = ratified_items.map{|x| [x.licitation_process_ratification.creditor, x.licitation_process_ratification_id]}.uniq
    result = []

    creditors.each do |creditor|
      sum = 0
      ratified_items.each do |ratified_item|
        if ratified_item&.licitation_process_ratification_id == creditor[1]
          item = ratified_item.purchase_process_item
          sum += (item&.quantity || 0) * (item&.unit_price || 0)
        end
      end
      result.push([creditor[0], sum])
    end

    result
  end

  def modality
    licitation_process.type_of_removal_humanize
  end

  protected

  def normalize_attributes
    { :licitation_process => licitation_process_id }
  end
end
