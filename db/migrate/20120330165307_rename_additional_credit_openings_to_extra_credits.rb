class RenameAdditionalCreditOpeningsToExtraCredits < ActiveRecord::Migration
  def change
    rename_table :additional_credit_openings, :extra_credits

    rename_column :additional_credit_opening_moviment_types, :additional_credit_opening_id, :extra_credit_id
  end
end
