class RenameColumnValidRessonToValidReasonOnTableLicitationProcessImpugnments < ActiveRecord::Migration
  def change
    rename_column :licitation_process_impugnments, :valid_resson, :valid_reason
  end
end
