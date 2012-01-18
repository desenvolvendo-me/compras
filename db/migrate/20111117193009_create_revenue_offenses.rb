class CreateRevenueOffenses < ActiveRecord::Migration
  def change
    create_table :revenue_offenses do |t|
      t.string :name

      t.timestamps
    end
  end
end
