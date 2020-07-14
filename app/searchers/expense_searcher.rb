class ExpenseSearcher
  include Quaestio

  repository Expense

  def organ_id(param)
    where { organ_id.eq(param) }
  end

  def purchasing_unit_id(param)
    where { purchase_unit_id.eq(param) }
  end
end
