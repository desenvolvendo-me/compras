class CreateContributionImprovementReasons < ActiveRecord::Migration
  def change
    create_table :contribution_improvement_reasons do |t|
      t.string :name

      t.timestamps
    end
  end
end
