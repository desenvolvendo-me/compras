class PaymentType < EnumerateIt::Base
  associate_values :cash, :check, :automatic_debit
end
