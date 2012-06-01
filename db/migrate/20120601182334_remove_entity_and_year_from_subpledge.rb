class RemoveEntityAndYearFromSubpledge < ActiveRecord::Migration
  def change
    change_table :subpledges do |t|
      t.remove :entity_id
      t.remove :year
    end
  end
end
