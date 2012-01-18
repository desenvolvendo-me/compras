class CreateBranchActivities < ActiveRecord::Migration
  def change
    create_table :branch_activities do |t|
      t.string :name
      t.references :cnae
      t.references :branch_classification
      t.boolean :incidence_of_substitution_tax, :default => false
      t.references :list_service
      t.boolean :allow_tax_deduction, :default => false
      t.boolean :issqn_in_local, :default => false

      t.timestamps
    end
    add_index :branch_activities, :cnae_id
    add_index :branch_activities, :branch_classification_id
    add_index :branch_activities, :list_service_id
    add_foreign_key :branch_activities, :cnaes
    add_foreign_key :branch_activities, :branch_classifications
    add_foreign_key :branch_activities, :list_services
  end
end
