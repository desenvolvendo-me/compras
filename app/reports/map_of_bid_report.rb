class MapOfBidReport < Report
  include Decore::Infection

  attr_accessor :licitation_process_id

  def purchase_process
    record.purchase_process
  end

  def proposals_by_item(item)
    return if purchase_process.nil?

    purchase_process.creditor_proposals.by_item_id(item.id)
  end

  def average_unit_price_item(item)
    return  if item.nil?

    item.unit_price
  end

  def average_total_price_item(item)
    return  if item.nil?

    average_unit_price_item(item) * item.quantity
  end

  def bids_grouped_by_item
    record.items_bids.order('amount DESC').group_by(&:item_id)
  end

  def bids_grouped_by_lot
    record.items_bids.order('lot, number ASC').group_by(&:lot)
  end

  def trading_items
    record.items
  end

  def lots
    items.lots
  end

  def proposals_by_lot(lot)
    purchase_process.creditor_proposals.by_lot(lot)
  end

  def items_by_lot(lot)
    items.lot(lot)
  end

  protected

  def items
    purchase_process.items
  end

  def record
    records.first
  end

  def normalize_attributes
    { :licitation_process => licitation_process_id }
  end
end
