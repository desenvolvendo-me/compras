class CreateContributionImprovementsProperties < ActiveRecord::Migration
  def change
    create_table :contribution_improvements_properties, :id => false do |t|
      t.references :contribution_improvement
      t.references :property
    end
    add_index :contribution_improvements_properties, :contribution_improvement_id, :name => :ci_index
    add_index :contribution_improvements_properties, :property_id
    add_foreign_key :contribution_improvements_properties, :contribution_improvements, :name => :ci_foreign_key
    add_foreign_key :contribution_improvements_properties, :properties
  end
end
