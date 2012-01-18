class RemoveMaxValueFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :max_value
  end
end
