class AddAdministrationTypeToOrganograms < ActiveRecord::Migration
  def change
    add_column :organograms, :administration_type_id, :integer
    add_index :organograms, :administration_type_id
    add_foreign_key :organograms, :administration_types
  end
end
