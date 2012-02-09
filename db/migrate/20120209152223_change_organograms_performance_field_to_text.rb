class ChangeOrganogramsPerformanceFieldToText < ActiveRecord::Migration
  def up
    change_column :organograms, :performance_field, :text
  end

  def down
    change_column :organograms, :performance_field, :string
  end
end
