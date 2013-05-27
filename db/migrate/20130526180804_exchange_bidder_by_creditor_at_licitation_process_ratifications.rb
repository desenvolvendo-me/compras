class ExchangeBidderByCreditorAtLicitationProcessRatifications < ActiveRecord::Migration
  def change
    add_column :compras_licitation_process_ratifications, :creditor_id, :integer

    add_index :compras_licitation_process_ratifications, :creditor_id
    add_foreign_key :compras_licitation_process_ratifications, :compras_creditors, column: :creditor_id

    execute <<-SQL
      UPDATE compras_licitation_process_ratifications
      SET creditor_id = b.creditor_id
      FROM compras_bidders b
      WHERE b.id = bidder_id
    SQL

    remove_column :compras_licitation_process_ratifications, :bidder_id
  end
end
