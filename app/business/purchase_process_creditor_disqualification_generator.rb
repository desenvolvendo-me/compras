class PurchaseProcessCreditorDisqualificationGenerator
  def initialize(purchase_process)
    @purchase_process = purchase_process
  end
  # @param [LicitationProcess]
  # Desqualifa fornecedores para o procecsso de compra em que:
  # Tenham cadastrados propostas com valores inferiores ou superiores aos estipulados
  # no Criterio de Classificação
  def self.create!(*params)
    new(*params).create_desqualification!
  end

  def create_desqualification!
    return if disqualify_proposal_below.zero? && disqualify_proposal_above.zero?

    creditors_with_proposals.each do |creditor|
      if disqualified_by_minimum(creditor) or disqualified_by_maximum(creditor)
        creditor_disqualification = build_disqualification_for(creditor)
        creditor_disqualification.save
      end
    end
  end

  private
  attr_reader :purchase_process

  def creditors_with_proposals
    purchase_process.creditor_proposals.includes(:creditor).map(&:creditor)
  end

  def taken_price
    purchase_process.items_total_price
  end

  def disqualify_proposal_below
    purchase_process.disqualify_proposal_below || 0.0
  end

  def disqualify_proposal_above
    purchase_process.disqualify_proposal_above || 0.0
  end

  def minimum_price
    taken_price - (taken_price * disqualify_proposal_below/100)
  end

  def max_price
    taken_price + (taken_price * disqualify_proposal_above/100)
  end

  def proposals_total_price(creditor)
    purchase_process.proposals_total_price(creditor)
  end

  def disqualified_by_minimum creditor
    proposals_total_price(creditor) < minimum_price
  end

  def disqualified_by_maximum creditor
    proposals_total_price(creditor) > max_price
  end


  def build_disqualification_for creditor
    creditor_disqualification = PurchaseProcessCreditorDisqualification
                                    .where(creditor_id: creditor.id, licitation_process_id: purchase_process.id)
                                    .first_or_initialize

    creditor_disqualification.licitation_process    = purchase_process
    creditor_disqualification.creditor              = creditor
    creditor_disqualification.disqualification_date = Date.today
    creditor_disqualification.kind                  = PurchaseProcessCreditorDisqualificationKind::TOTAL

    if disqualified_by_minimum(creditor)
      creditor_disqualification.reason = I18n.t('purchase_process_creditor_disqualification.messages.disqualificated_by_minimum_value',
                                           disqualify_below: disqualify_proposal_below)
    else
      creditor_disqualification.reason = I18n.t('purchase_process_creditor_disqualification.messages.disqualificated_by_maximum_value',
                                          disqualify_above: disqualify_proposal_above)
    end

    creditor_disqualification
  end

end
