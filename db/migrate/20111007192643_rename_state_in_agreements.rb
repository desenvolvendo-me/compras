class RenameStateInAgreements < ActiveRecord::Migration
  def change
    rename_column :agreements, :state, :status
  end
end
