class RemoveColumnBranchActivitiesIncidenceOfSubstitutionTax < ActiveRecord::Migration
  def change
    remove_column :branch_activities, :incidence_of_substitution_tax
  end
end
