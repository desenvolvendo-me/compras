class CreateAdditionalCreditOpenings < ActiveRecord::Migration
  def change
    create_table :additional_credit_openings do |t|
      t.references :entity
      t.integer :year
      t.string :credit_type

      t.timestamps
    end

    add_index :additional_credit_openings, :entity_id

    add_foreign_key :additional_credit_openings, :entities
  end
end
