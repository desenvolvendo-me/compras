module RealignmentPricesHelper
  def proposals(purchase_process, creditor)
    PurchaseProcessCreditorProposal.
      licitation_process_id(purchase_process.id).
      creditor_id(creditor.id).
      winning_proposals.
      reorder("CREDITOR_ID ASC, LOT ASC")
  end

  def trading_items(purchase_process, creditor)
    PurchaseProcessTradingItem.
      purchase_process_id(purchase_process.id).
      creditor_winner_items(creditor.id).
      sort_by(&:lot)
  end

  def items_or_build(realignment)
    if realignment.items.any?
      realignment.items
    else
      build_items(realignment)
    end
  end

  def realignment_path_helper(purchase_process_id, creditor_id, lot = nil)
    realignment = RealignmentPrice.
      purchase_process_id(purchase_process_id).
      creditor_id(creditor_id).
      lot(lot).
      first

    if realignment
      edit_realignment_price_path(realignment)
    else
      new_realignment_price_path(purchase_process_id: purchase_process_id, creditor_id: creditor_id, lot: lot)
    end
  end

  def realignment_link_title(purchase_process_id, creditor_id, lot = nil)
    realignment = RealignmentPrice.
      purchase_process_id(purchase_process_id).
      creditor_id(creditor_id).
      lot(lot).
      first

    if realignment
      'Editar realinhamento de preço'
    else
      'Criar realinhamento de preço'
    end
  end

  private

  def build_items(realignment)
    items = []

    realignment.purchase_process_items.each do |item|
      if item.creditor_winner == realignment.creditor
        items << realignment.items.build(
          purchase_process_item_id: item.id,
          price: 0)
      end
    end

    items
  end
end
