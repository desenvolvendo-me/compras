class ExpenseDestineType < EnumerateIt::Base
  associate_values :special_operation, :project, :activity
end