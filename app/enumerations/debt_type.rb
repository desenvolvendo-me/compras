class DebtType < EnumerateIt::Base
  associate_values :nothing => 0,
    :contract => 1,
    :secutities => 2
end
