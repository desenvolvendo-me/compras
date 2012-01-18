class AddIndexOnFootageReferenceUnitIdOnContributionImprovements < ActiveRecord::Migration
  def change
    add_index :contribution_improvements, :footage_reference_unit_id
  end
end
