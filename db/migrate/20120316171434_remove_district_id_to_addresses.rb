class RemoveDistrictIdToAddresses < ActiveRecord::Migration
  def change
    remove_foreign_key :addresses, :districts
    remove_index       :addresses, :column => :district_id
    remove_column      :addresses, :district_id
  end
end
