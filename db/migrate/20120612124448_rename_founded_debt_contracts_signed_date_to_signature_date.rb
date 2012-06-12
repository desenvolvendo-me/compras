class RenameFoundedDebtContractsSignedDateToSignatureDate < ActiveRecord::Migration
  def change
    rename_column :founded_debt_contracts, :signed_date, :signature_date
  end
end
