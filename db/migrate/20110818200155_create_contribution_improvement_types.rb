class CreateContributionImprovementTypes < ActiveRecord::Migration
  def change
    create_table :contribution_improvement_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
