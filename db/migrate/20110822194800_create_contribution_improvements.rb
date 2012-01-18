class CreateContributionImprovements < ActiveRecord::Migration
  def change
    create_table :contribution_improvements do |t|
      t.string :name
      t.references :currency
      t.references :contribution_improvement_type
      t.text :description
      t.references :street
      t.references :neighborhood
      t.references :contribution_improvement_situation
      t.references :contribution_improvement_reason
      t.date :contribution_improvement_start_at
      t.date :contribution_improvement_end_at
      t.string :tender_process_number
      t.date :tender_process_date
      t.decimal :footage, :precision => 10, :scale => 2
      t.integer :footage_reference_unit_id
      t.decimal :unitary_cost, :precision => 10, :scale => 2
      t.decimal :percentage_split, :precision => 10, :scale => 2
      t.integer :maximum_number_plots
      t.decimal :interest_percentage, :precision => 10, :scale => 2
      t.references :type_interest
      t.text :descriptive_history
      t.text :notes

      t.timestamps
    end
    add_index :contribution_improvements, :currency_id
    add_index :contribution_improvements, :contribution_improvement_type_id, :name => "index_on_contribution_improvement_type_id"
    add_index :contribution_improvements, :street_id
    add_index :contribution_improvements, :neighborhood_id
    add_index :contribution_improvements, :contribution_improvement_situation_id, :name => "index_on_contribution_improvement_situation_id"
    add_index :contribution_improvements, :contribution_improvement_reason_id, :name => "index_on_contribution_improvement_reason_id"
    add_index :contribution_improvements, :type_interest_id
    add_foreign_key :contribution_improvements, :currencies
    add_foreign_key :contribution_improvements, :contribution_improvement_types, :name => "contribution_improvement_type_id_fk"
    add_foreign_key :contribution_improvements, :streets
    add_foreign_key :contribution_improvements, :neighborhoods
    add_foreign_key :contribution_improvements, :contribution_improvement_situations, :name => "contribution_improvement_situation_id_fk"
    add_foreign_key :contribution_improvements, :contribution_improvement_reasons, :name => "contribution_improvement_reason_id_fk"
    add_foreign_key :contribution_improvements, :type_interests
  end
end
