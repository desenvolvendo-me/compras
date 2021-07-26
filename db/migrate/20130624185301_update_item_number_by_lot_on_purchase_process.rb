class UpdateItemNumberByLotOnPurchaseProcess < ActiveRecord::Migration
  def change
    PurchaseProcessItem.order([:licitation_process_id, :lot]).each do |item|
      item.update_column(:item_number, next_item_number(item))
    end
  end

  private

  def next_item_number(item)
    (max_item_number(item) || 0 ) + 1
  end

  def max_item_number(item)
    PurchaseProcessItem.where { |query|
      query.licitation_process_id.eq(item.licitation_process_id) &
      query.lot.eq(item.lot) }.
      order([:licitation_process_id, :lot]).
      maximum(:item_number)
  end
end
