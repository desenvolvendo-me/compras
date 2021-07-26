class AddStartDateAndEndDateToSignatures < ActiveRecord::Migration
  def change
    change_table :compras_signatures do |t|
      t.date :start_date
      t.date :end_date
    end
  end
end
