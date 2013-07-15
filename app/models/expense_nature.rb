class ExpenseNature < UnicoAPI::Resources::Contabilidade::ExpenseNature
  def to_s
    "#{expense_nature} - #{description}"
  end
end
