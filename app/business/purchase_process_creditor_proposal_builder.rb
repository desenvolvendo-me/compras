class PurchaseProcessCreditorProposalBuilder
  def self.item_proposals(proposals, creditor_id)
    build_or_find(proposals, { creditor_id: creditor_id.to_i })
  end

  def self.lot_proposals(purchase_process, creditor_id)
    attrs = { licitation_process_id: purchase_process.id, creditor_id: creditor_id.to_i }

    [].tap do |proposals|
      purchase_process.each_item_lot do |lot|
        attrs.merge!(lot: lot)
        proposals << build_or_find(purchase_process.creditor_proposals, attrs)
      end
    end
  end

  def self.global_proposals(purchase_process, creditor_id)
    attrs = { licitation_process_id: purchase_process.id, creditor_id: creditor_id.to_i,
              lot: nil, purchase_process_item_id: nil }

    build_or_find(purchase_process.creditor_proposals, attrs)
  end

  private

  def self.build_or_find(proposals, attrs = {})
    proposal   = proposals.select { |c| c.new_record? && check_attrs(c, attrs) }.first
    proposal ||= proposals.select { |c| check_attrs(c, attrs) }.first
    proposal ||= proposals.where(attrs).first
    proposal ||= proposals.build(attrs)

    proposal
  end

  def self.check_attrs(proposal, attrs)
    attrs.each { |k, v| return false unless proposal[k] == v }
    true
  end
end
