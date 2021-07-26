class ContractStatus < EnumerateIt::Base
  associate_values :finished,:current
end