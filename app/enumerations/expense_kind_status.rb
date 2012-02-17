class ExpenseKindStatus < EnumerateIt::Base
  associate_values :active, :inactive
end
