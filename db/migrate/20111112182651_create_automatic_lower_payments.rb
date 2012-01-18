class CreateAutomaticLowerPayments < ActiveRecord::Migration
  def change
    create_table :automatic_lower_payments do |t|
      t.string :uploaded_document
      t.string :status

      t.timestamps
    end
  end
end
