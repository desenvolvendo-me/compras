class CreateStnOrdinances < ActiveRecord::Migration
  def change
    create_table :stn_ordinances do |t|
      t.string :description

      t.timestamps
    end
  end
end
