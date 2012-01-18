class CreateFiscalInfractions < ActiveRecord::Migration
  def change
    create_table :fiscal_infractions do |t|
      t.decimal :value, :precision => 10, :scale => 2
      t.integer :quantity
      t.references :fiscal_notification
      t.references :infraction

      t.timestamps
    end
    add_index :fiscal_infractions, :infraction_id
    add_index :fiscal_infractions, :fiscal_notification_id
    add_foreign_key :fiscal_infractions, :infractions
    add_foreign_key :fiscal_infractions, :fiscal_notifications
  end
end
