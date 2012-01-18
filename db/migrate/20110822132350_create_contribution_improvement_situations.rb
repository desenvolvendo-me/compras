class CreateContributionImprovementSituations < ActiveRecord::Migration
  def change
    create_table :contribution_improvement_situations do |t|
      t.string :name

      t.timestamps
    end
  end
end
