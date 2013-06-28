class PurchaseProcessCreditorProposalBuilder
  def initialize(licitation_process, creditor)
    @licitation_process = licitation_process
    @creditor           = creditor
    @kind               = licitation_process.judgment_form_kind
  end

  def self.build_proposals(*attributes)
    self.new(*attributes).proposals
  end

  def proposals
    [].tap do |all_proposals|
      each_object do |item|
        all_proposals << build_creditor_proposal(item)
      end
    end
  end

  private

  attr_reader :licitation_process, :creditor, :kind

  def each_object
    send(kind).each do |item|
      yield item
    end
  end

  def build_creditor_proposal(item)
    creditor_proposal = licitation_process.creditor_proposals.build
    creditor_proposal.creditor_id = creditor.id

    creditor_proposal.purchase_process_item_id = item.id if licitation_process.judgment_form_item?
    creditor_proposal.lot = item                         if licitation_process.judgment_form_lot?

    creditor_proposal
  end

  def item
    licitation_process.items
  end

  def lot
    licitation_process.items.map(&:lot).uniq
  end

  def global
    [licitation_process]
  end
end
