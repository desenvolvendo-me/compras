class RemoveTableTypeImprovements < ActiveRecord::Migration
  def change
    drop_table :type_improvements
  end
end
