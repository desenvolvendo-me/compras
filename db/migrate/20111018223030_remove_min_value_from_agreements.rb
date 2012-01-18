class RemoveMinValueFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :min_value
  end
end
