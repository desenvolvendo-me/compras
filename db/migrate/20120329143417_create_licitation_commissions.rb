class CreateLicitationCommissions < ActiveRecord::Migration
  def change
    create_table :licitation_commissions do |t|
      t.string :commission_type
      t.date :nomination_date
      t.date :expiration_date
      t.date :exoneration_date
      t.text :description

      t.timestamps
    end
  end
end
