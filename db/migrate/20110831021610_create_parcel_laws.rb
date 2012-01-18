class CreateParcelLaws < ActiveRecord::Migration
  def change
    create_table :parcel_laws do |t|
      t.string :name

      t.timestamps
    end
  end
end
