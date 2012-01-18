class CreateTypeExemptions < ActiveRecord::Migration
  def change
    create_table :type_exemptions do |t|
      t.string :name
      t.string :abbr

      t.timestamps
    end
  end
end
