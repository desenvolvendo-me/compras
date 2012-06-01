class RemoveEntityAndYearFromSubpledgeCancellation < ActiveRecord::Migration
  def change
    change_table :subpledge_cancellations do |t|
      t.remove :entity_id
      t.remove :year
    end
  end
end
