class RenameAdditionalCreditOpeningNaturesToExtraCreditNatures < ActiveRecord::Migration
  def change
    rename_table :additional_credit_opening_natures, :extra_credit_natures

    rename_column :extra_credits, :additional_credit_opening_nature_id, :extra_credit_nature_id
  end
end
