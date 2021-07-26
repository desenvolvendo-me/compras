class MapOfProposalReport < Report
  include Decore::Infection

  attr_accessor :order, :licitation_process_id

  has_enumeration_for :order, with: MapProposalReportOrder

  validates :order, :presence => true

  def licitation_process
    licitation_process_repository.find(licitation_process_id)
  end

  def item_creditor_proposals(item)
    records.by_item_id(item.id)
  end

  def average_unit_price_item(item)
    item.unit_price
  end

  def average_total_price_item(item)
    average_unit_price_item(item) * item.quantity
  end

  def lot_creditor_proposal(lot)
    records.by_lot(lot)
  end

  def lots
    items.lots
  end

  def items_by_lot(lot)
    items.lot(lot)
  end

  protected

  def items
    licitation_process.items
  end

  def licitation_process_repository
    @licitation_process_repository ||= LicitationProcess
  end

  def normalize_attributes
    params = {}

    params[:licitation_process] = licitation_process_id
    params[:order] = order

    params
  end
end
