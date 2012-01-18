class CreateWriteOffTypePayments < ActiveRecord::Migration
  def change
    create_table :write_off_type_payments do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
  end
end
