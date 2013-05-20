class CreateExtendedPartners < ActiveRecord::Migration
  def change
    create_table :compras_extended_partners do |t|
      t.integer :partner_id, null: false
      t.string  :society_kind
    end

    add_index :compras_extended_partners, :partner_id
    add_foreign_key :compras_extended_partners, :unico_partners, column: :partner_id
  end
end
