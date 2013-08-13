class AddRealignmentPriceToLicitationProcessRatificationItems < ActiveRecord::Migration
  def change
    add_column :compras_licitation_process_ratification_items, :realignment_price_item_id, :integer

    add_index :compras_licitation_process_ratification_items, :realignment_price_item_id,
      name: :clpri_realignment_price_item_idx

    add_foreign_key :compras_licitation_process_ratification_items,
      :compras_realignment_price_items, column: :realignment_price_item_id,
      name: :clpri_realignment_price_item_fk
  end
end
