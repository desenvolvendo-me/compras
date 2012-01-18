class PaymentStates < EnumerateIt::Base
  associate_values :normal, :improper, :canceled, :suspended, :paid
end
