class RenameColumnValidRessonToValidReasonOnTableLicitationProcessImpugnments < ActiveRecord::Migration
  def change
    rename_column :licitation_process_impugnments, :valid_reason, :valid_reason
  end
end
