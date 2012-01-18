class RemoveProcessFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :process
  end
end
