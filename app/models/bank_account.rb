class BankAccount < Unico::BankAccount
  attr_accessible  :kind, :bank_id, :agency_id, :account_number, :digit, :description

end
