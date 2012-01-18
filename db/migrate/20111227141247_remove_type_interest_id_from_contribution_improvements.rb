class RemoveTypeInterestIdFromContributionImprovements < ActiveRecord::Migration
  def change
    remove_column :contribution_improvements, :type_interest_id
  end
end
