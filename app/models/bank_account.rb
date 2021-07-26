class BankAccount < Unico::BankAccount
  def bank
    agency.try(:bank) || @bank
  end

  def bank_id
    agency.try(:bank_id) || @bank_id
  end
end
