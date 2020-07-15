class ExpenseSearcher
  include Quaestio

  repository Expense

  def organ_id(param)
    where { organ_id.eq(param) }
  end

  def unity_id(param)
    where { unity_id.eq(param) }
  end

end
