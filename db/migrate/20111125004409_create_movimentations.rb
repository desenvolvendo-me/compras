class CreateMovimentations < ActiveRecord::Migration
  def change
    create_table :movimentations do |t|
      t.date :movimentation_date
      t.string :situation
      t.text :opinion
      t.references :fiscal_notification

      t.timestamps
    end
    add_index :movimentations, :fiscal_notification_id
    add_foreign_key :movimentations, :fiscal_notifications
  end
end
