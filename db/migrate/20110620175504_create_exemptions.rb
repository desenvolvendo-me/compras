class CreateExemptions < ActiveRecord::Migration
  def change
    create_table :exemptions do |t|
      t.string :name
      t.string :law
      t.date :date_law
      t.references :type_exemption
      t.text :notes

      t.timestamps
    end
    add_index :exemptions, :type_exemption_id
    add_foreign_key :exemptions, :type_exemptions
  end
end
